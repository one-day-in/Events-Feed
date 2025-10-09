import Foundation
import Combine

// Базовий клієнт для всіх музичних сервісів
class BaseMusicServiceClient<
    Constants: MusicServiceConstants,
    AuthHandler: BaseWebAuthHandler<Constants>,
    TokenStorage: BaseTokenStorage<Constants>
>: ObservableObject, MusicServiceProtocol {
    
    internal let webAuthHandler: AuthHandler
    internal let tokenStorage: TokenStorage
    internal let errorService: ErrorService
    internal let serviceType: MusicServiceType
    
    @Published public var isConnected = false
    @Published public var errorMessage: String? = nil
    @Published public var isLoading = false
    
    init(
        webAuthHandler: AuthHandler,
        tokenStorage: TokenStorage,
        errorService: ErrorService,
        serviceType: MusicServiceType
    ) {
        self.webAuthHandler = webAuthHandler
        self.tokenStorage = tokenStorage
        self.errorService = errorService
        self.serviceType = serviceType
        
        // Відновлюємо стан при ініціалізації
        updateConnectionState()
    }
    
    // MARK: - Публічний інтерфейс (MusicServiceProtocol)
    
    func authenticate() {
        isLoading = true
        errorMessage = nil
        
        print("🎵 Запуск авторизації \(serviceType.rawValue)")
        authenticateViaWeb()
    }
    
    func handleAuthCallback(url: URL) {
        print("🎵 Обробка callback \(serviceType.rawValue): \(url)")
        
        webAuthHandler.handleCallback(url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.handleAuthSuccess(accessToken: token)
                case .failure(let error):
                    self?.handleError(error.localizedDescription)
                }
                self?.isLoading = false
            }
        }
    }
    
    func isAuthenticated() -> Bool {
        return tokenStorage.getAccessToken() != nil
    }
    
    func disconnect() {
        tokenStorage.clearTokens()
        
        DispatchQueue.main.async {
            self.isConnected = false
            self.isLoading = false
        }
        
        print("🔌 Відключено від \(serviceType.rawValue)")
        
        // Відправляємо сповіщення для зворотної сумісності
        NotificationCenter.default.post(
            name: serviceType.legacyDisconnectNotificationName,
            object: nil
        )
    }
    
    func getAccessToken() -> String? {
        return tokenStorage.getAccessToken()
    }
    
    // MARK: - Внутрішня логіка
    
    internal func authenticateViaWeb() {
        webAuthHandler.authenticateViaWeb() { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let accessToken):
                    self?.handleAuthSuccess(accessToken: accessToken)
                case .failure(let error):
                    self?.handleError(error.localizedDescription)
                }
            }
        }
    }
    
    internal func handleAuthSuccess(accessToken: String) {
        tokenStorage.saveAccessToken(accessToken)
        print("✅ Успішна автентифікація \(serviceType.rawValue)! Токен отримано")
        
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
    
    internal func handleError(_ message: String) {
        print("❌ Помилка \(serviceType.rawValue): \(message)")
        errorMessage = message
        
        // Використовуємо існуючі методи ErrorService
        switch serviceType {
        case .spotify:
            errorService.reportSpotifyError(message)
        case .youtubeMusic:
            errorService.reportYouTubeMusicError(message)
        case .appleMusic:
            errorService.report(.unknown(description: message))
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        
        // Відправляємо сповіщення про помилку
        NotificationCenter.default.post(
            name: serviceType.legacyErrorNotificationName,
            object: message
        )
    }
    
    internal func updateConnectionState() {
        self.isConnected = isAuthenticated()
    }
}
