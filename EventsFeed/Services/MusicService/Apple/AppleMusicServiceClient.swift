// AppleMusicServiceClient.swift
import Foundation
import MusicKit
import MediaPlayer

final class AppleMusicServiceClient: BaseMusicServiceClient<
    AppleMusicConstants,
    AppleMusicAuthHandler,
    AppleMusicTokenStorage
> {
    
    // Додаємо властивість для відстеження стану підключення
    private var hasExplicitlyConnected: Bool {
        get {
            UserDefaults.standard.bool(forKey: "AppleMusicExplicitlyConnected")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AppleMusicExplicitlyConnected")
        }
    }
    
    // MARK: - Специфічні методи для Apple Music
    
    func requestMediaLibraryAuthorization() async -> Bool {
        let status = await MPMediaLibrary.requestAuthorization()
        return status == .authorized
    }
    
    func checkMusicSubscription() async -> Bool {
        do {
            let subscription = try await MusicSubscription.current
            return subscription.canPlayCatalogContent
        } catch {
            print("❌ Помилка перевірки підписки: \(error)")
            return false
        }
    }
    
    // Отримання плейлистів користувача
    func getUserPlaylists() async throws -> MusicItemCollection<Playlist> {
        guard isAuthenticated() else {
            throw MusicServiceAuthError.noAccessToken
        }
        
        let request = MusicLibraryRequest<Playlist>()
        let response = try await request.response()
        return response.items
    }
    
    // Пошук музики
    func searchCatalog(_ query: String) async throws -> MusicCatalogSearchResponse {
        guard isAuthenticated() else {
            throw MusicServiceAuthError.noAccessToken
        }
        
        var request = MusicCatalogSearchRequest(term: query, types: [Song.self, Album.self, Playlist.self])
        request.limit = 25
        return try await request.response()
    }
    
    // Отримання рекомендованих плейлистів
    func getRecommendedPlaylists() async throws -> MusicItemCollection<Playlist> {
        guard isAuthenticated() else {
            throw MusicServiceAuthError.noAccessToken
        }
        
        let request = MusicPersonalRecommendationsRequest()
        let response = try await request.response()
        return response.recommendations.first?.playlists ?? MusicItemCollection<Playlist>()
    }
    
    // Отримання нещодавно відтворених
    func getRecentlyPlayed() async throws -> MusicItemCollection<Song> {
        guard isAuthenticated() else {
            throw MusicServiceAuthError.noAccessToken
        }
        
        let request = MusicLibraryRequest<Song>()
        let response = try await request.response()
        return response.items
    }
    
    // MARK: - Перевизначення методів базового класу
    
    override func authenticate() {
        isLoading = true
        errorMessage = nil
        
        print("🎵 Запуск нативної авторизації Apple Music...")
        
        Task { @MainActor in
            await performNativeAuthentication()
        }
    }
    
    override func handleAuthCallback(url: URL) {
        // Apple Music не використовує URL callback
        print("ℹ️ Apple Music uses native authorization, not URL callbacks")
    }
    
    override func isAuthenticated() -> Bool {
        // Перевіряємо як системну авторизацію, так і явне підключення
        return MusicAuthorization.currentStatus == .authorized && hasExplicitlyConnected
    }
    
    override func getAccessToken() -> String? {
        return "apple_music_native_access"
    }
    
    override func disconnect() {
        // Скидаємо стан явного підключення
        hasExplicitlyConnected = false
        tokenStorage.clearTokens()
        
        DispatchQueue.main.async {
            self.isConnected = false
            self.isLoading = false
        }
        
        print("🔌 Відключено від Apple Music")
        
        NotificationCenter.default.post(
            name: MusicServiceType.appleMusic.legacyDisconnectNotificationName,
            object: nil
        )
    }
    
    // MARK: - Конструктори
    
    convenience init(errorService: ErrorService = .shared) {
        let authHandler = AppleMusicAuthHandler()
        let tokenStorage = AppleMusicTokenStorage()
        
        self.init(
            webAuthHandler: authHandler,
            tokenStorage: tokenStorage,
            errorService: errorService,
            serviceType: .appleMusic
        )
        
        // Оновлюємо стан при ініціалізації
        updateConnectionState()
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func performNativeAuthentication() async {
        do {
            // 1. Авторизація через MusicKit
            print("1. Авторизація MusicKit...")
            let musicStatus = await MusicAuthorization.request()
            
            switch musicStatus {
            case .authorized:
                print("✅ MusicKit авторизовано!")
                
                // 2. Запит дозволу на доступ до медіатеки
                print("2. Запит доступу до медіатеки...")
                let mediaAuthorized = await requestMediaLibraryAuthorization()
                
                // 3. Перевірка підписки
                print("3. Перевірка підписки Apple Music...")
                let hasSubscription = await checkMusicSubscription()
                
                if hasSubscription {
                    // Встановлюємо прапорець явного підключення
                    self.hasExplicitlyConnected = true
                    handleAuthSuccess(accessToken: "apple_music_native_access")
                    print("✅ Активна підписка Apple Music")
                } else {
                    // Все одно вважаємо успіхом, але показуємо попередження
                    self.hasExplicitlyConnected = true
                    handleAuthSuccess(accessToken: "apple_music_native_access")
                    print("⚠️ Підписка Apple Music не активна, але авторизація успішна")
                    await MainActor.run {
                        self.errorMessage = "Підписка Apple Music не активна. Деякі функції можуть бути обмежені."
                    }
                }
                
                if !mediaAuthorized {
                    print("⚠️ Доступ до медіатеки не надано")
                }
                
            case .denied:
                throw MusicServiceAuthError.accessDenied
            case .notDetermined:
                throw MusicServiceAuthError.notDetermined
            case .restricted:
                throw MusicServiceAuthError.restricted
            @unknown default:
                throw MusicServiceAuthError.serviceError("Невідомий статус авторизації")
            }
            
        } catch {
            handleError(error.localizedDescription)
        }
    }
    
    // Перевизначаємо метод успішної авторизації
    internal override func handleAuthSuccess(accessToken: String) {
        tokenStorage.saveAccessToken(accessToken)
        print("✅ Успішна автентифікація Apple Music!")
        
        self.isConnected = true
        self.isLoading = false
        
        errorMessage = nil
        errorService.clearCurrentError()
        
        // Відправляємо сповіщення для зворотної сумісності
        NotificationCenter.default.post(
            name: serviceType.legacyNotificationName,
            object: accessToken
        )
    }
    
    // Оновлюємо стан підключення
    internal override func updateConnectionState() {
        self.isConnected = isAuthenticated()
    }
}
