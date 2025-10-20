import Foundation
import Combine

@MainActor
final class MusicServiceManager: ObservableObject {
    @Published var connectedServices: [MusicServiceType] = []
    
    private let spotifyClient: SpotifyServiceClient
    private let youTubeMusicClient: YouTubeMusicServiceClient
    private let appleMusicClient: AppleMusicServiceClient
    private let errorService: ErrorService
    private let notificationService: NotificationService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        spotifyClient: SpotifyServiceClient,
        youTubeMusicClient: YouTubeMusicServiceClient,
        appleMusicClient: AppleMusicServiceClient,
        errorService: ErrorService,
        notificationService: NotificationService = .shared
    ) {
        self.spotifyClient = spotifyClient
        self.youTubeMusicClient = youTubeMusicClient
        self.appleMusicClient = appleMusicClient
        self.errorService = errorService
        self.notificationService = notificationService
        
        updateConnectedServices()
        setupObservers()
    }
    
    func connectService(_ serviceType: MusicServiceType) {
        switch serviceType {
        case .spotify:
            spotifyClient.authenticate()
        case .youtubeMusic:
            youTubeMusicClient.authenticate()
        case .appleMusic:
            appleMusicClient.authenticate()
        }
    }
    
    func disconnectService(_ serviceType: MusicServiceType) {
        switch serviceType {
        case .spotify:
            spotifyClient.disconnect()
        case .youtubeMusic:
            youTubeMusicClient.disconnect()
        case .appleMusic:
            appleMusicClient.disconnect()
        }
        
        updateConnectedServices()
    }
    
    func isServiceConnected(_ serviceType: MusicServiceType) -> Bool {
        switch serviceType {
        case .spotify: return spotifyClient.isConnected
        case .youtubeMusic: return youTubeMusicClient.isConnected
        case .appleMusic: return appleMusicClient.isConnected
        }
    }
    
    private func updateConnectedServices() {
        connectedServices = MusicServiceType.allCases.filter { isServiceConnected($0) }
        print("🎵 Оновлено підключені сервіси: \(connectedServices.map { $0.rawValue })")
    }
    
    private func setupObservers() {
        // Слухаємо зміни стану музичних сервісів
        notificationService.musicServiceConnectionChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] (serviceType, isConnected) in
                print("🔄 MusicServiceManager: \(serviceType.rawValue) - \(isConnected ? "підключено" : "відключено")")
                self?.updateConnectedServices()
            }
            .store(in: &cancellables)
        
        // Слухаємо успішну авторизацію
        notificationService.musicServiceAuthSuccess
            .sink { [weak self] serviceType, token in
                print("🎵 MusicServiceManager: успішна авторизація \(serviceType.rawValue)")
                self?.updateConnectedServices()
            }
            .store(in: &cancellables)
    }
}
