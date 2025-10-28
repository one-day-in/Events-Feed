import Foundation
import Combine

@MainActor
final class MusicServiceManager: ObservableObject {
    @Published private(set) var connectedServices: [MusicServiceType] = []
    // Сервіси
    private let spotifyClient: SpotifyServiceClient
    private let youtubeClient: YouTubeMusicServiceClient
    private let appleMusicClient: AppleMusicServiceClient
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        spotifyClient: SpotifyServiceClient,
        youtubeClient: YouTubeMusicServiceClient,
        appleMusicClient: AppleMusicServiceClient
    ) {
        self.spotifyClient = spotifyClient
        self.youtubeClient = youtubeClient
        self.appleMusicClient = appleMusicClient
        
        observeConnections()
        updateConnectedServices()
    }
    
    // MARK: - Public API
    
    func connectService(_ type: MusicServiceType) async throws {
        switch type {
        case .spotify:
            try await spotifyClient.authenticate()
        case .youtubeMusic:
            try await youtubeClient.authenticate()
        case .appleMusic:
            try await appleMusicClient.authenticate()
        }
        
        print("✅ Successfully connected \(type.rawValue)")
        updateConnectedServices()
    }
    
    func handleAuthCallback(_ url: URL) async throws -> Bool {
        // Спробуємо обробити через Spotify
        if try await spotifyClient.handleAuthCallback(url: url) {
            print("✅ Successfully handled callback for Spotify")
            updateConnectedServices()
            return true
        }
        
        // Спробуємо обробити через YouTube Music
        if try await youtubeClient.handleAuthCallback(url: url) {
            print("✅ Successfully handled callback for YouTube Music")
            updateConnectedServices()
            return true
        }
        
        return false
    }
    
    func restoreConnections() async throws {
        print("🎧 Restoring music service sessions...")
        
        // Відновлюємо сесії паралельно для швидкості
        async let spotifyRestore = restoreService(.spotify, client: spotifyClient)
        async let youtubeRestore = restoreService(.youtubeMusic, client: youtubeClient)
        async let appleRestore = restoreService(.appleMusic, client: appleMusicClient)
        
        let results = await (spotifyRestore, youtubeRestore, appleRestore)
        
        updateConnectedServices()
        
        let successful = [results.0, results.1, results.2].filter { $0 }.count
        print("🎧 Music services restoration completed: \(successful)/3 successful")
        
        // Якщо жоден сервіс не вдалось відновити, кидаємо помилку
        if successful == 0 {
            throw MusicServiceAuthError.tokenExpired
        }
    }
    
    private func restoreService(_ type: MusicServiceType, client: BaseMusicServiceClient) async -> Bool {
        do {
            try await client.restoreSession()
            print("✅ Successfully restored \(type.rawValue) session")
            return true
        } catch {
            print("🔴 Failed to restore \(type.rawValue) session: \(error)")
            return false
        }
    }
    
    func disconnectService(_ type: MusicServiceType) {
        switch type {
        case .spotify:
            spotifyClient.disconnect()
        case .youtubeMusic:
            youtubeClient.disconnect()
        case .appleMusic:
            appleMusicClient.disconnect()
        }
        
        updateConnectedServices()
        print("✅ Disconnected \(type.rawValue)")
    }
    
    func disconnectAll() {
        [spotifyClient, youtubeClient, appleMusicClient].forEach { $0.disconnect() }
        updateConnectedServices()
        print("✅ Disconnected all music services")
    }
    
    // MARK: - Helpers
    private func updateConnectedServices() {
        connectedServices = MusicServiceType.allCases.filter { isConnected($0) }
        print("🎧 Connected services: \(connectedServices.map(\.rawValue))")
    }
    
    private func isConnected(_ type: MusicServiceType) -> Bool {
        switch type {
        case .spotify: return spotifyClient.isConnected
        case .youtubeMusic: return youtubeClient.isConnected
        case .appleMusic: return appleMusicClient.isConnected
        }
    }
    
    private func observeConnections() {
        Publishers.Merge3(
            spotifyClient.$isConnected.map { (MusicServiceType.spotify, $0) },
            youtubeClient.$isConnected.map { (MusicServiceType.youtubeMusic, $0) },
            appleMusicClient.$isConnected.map { (MusicServiceType.appleMusic, $0) }
        )
        .sink { [weak self] _, _ in
            Task { @MainActor [weak self] in
                self?.updateConnectedServices()
            }
        }
        .store(in: &cancellables)
    }
}
