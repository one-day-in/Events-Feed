import Foundation
import Combine

@MainActor
final class MusicServiceManager: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var musicServices: [MusicService] = []
    var musicServicesPublisher: Published<[MusicService]>.Publisher { $musicServices }
    
    private let clients: [MusicServiceType: any MusicServiceProtocol]
    private let errorService: ErrorService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        spotifyClient: SpotifyServiceClient,
        youTubeMusicClient: YouTubeMusicServiceClient,
        appleMusicClient: AppleMusicServiceClient,
        errorService: ErrorService = .shared
    ) {
        self.clients = [
            .spotify: spotifyClient,
            .youtubeMusic: youTubeMusicClient,
            .appleMusic: appleMusicClient
        ]
        self.errorService = errorService
        
        setupObservers()
        updateMusicServices()
    }
    
    // MARK: - Public Methods
    func connectService(_ type: MusicServiceType) {
        clients[type]?.authenticate()
    }
    
    func disconnectService(_ type: MusicServiceType) {
        clients[type]?.disconnect()
    }
    
    func isServiceConnected(_ type: MusicServiceType) -> Bool {
        clients[type]?.isAuthenticated() ?? false
    }
    
    // MARK: - Private Methods
    private func setupObservers() {
        let notificationPairs: [(Notification.Name, MusicServiceType)] = [
            (.spotifyAuthSuccess, .spotify),
            (.spotifyDisconnected, .spotify),
            (.youtubeMusicAuthSuccess, .youtubeMusic),
            (.youtubeMusicDisconnected, .youtubeMusic),
            (.appleMusicAuthSuccess, .appleMusic),
            (.appleMusicDisconnected, .appleMusic)
        ]
        
        for (notification, serviceType) in notificationPairs {
            NotificationCenter.default.publisher(for: notification)
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.handleServiceUpdate(serviceType)
                }
                .store(in: &cancellables)
        }
    }
    
    private func handleServiceUpdate(_ type: MusicServiceType) {
        updateMusicServices()
    }
    
    private func handleServiceError(_ error: String, for type: MusicServiceType) {
        switch type {
        case .spotify:
            errorService.reportSpotifyError(error)
        case .youtubeMusic:
            errorService.reportYouTubeMusicError(error)
        case .appleMusic:
            errorService.reportAppleMusicError(error)
        }
    }
    
    private func updateMusicServices() {
        let updatedServices = MusicServiceType.allCases.compactMap { type in
            isServiceConnected(type) ? createMusicService(for: type) : nil
        }
            self.musicServices = updatedServices
    }
    
    private func createMusicService(for type: MusicServiceType) -> MusicService {
        switch type {
        case .spotify:
            return MusicService(
                id: "spotify",
                name: "Spotify",
                isConnected: true,
                iconName: "spotify",
                serviceType: .spotify
            )
        case .youtubeMusic:
            return MusicService(
                id: "youtube-music",
                name: "YouTube Music",
                isConnected: true,
                iconName: "play.circle.fill",
                serviceType: .youtubeMusic
            )
        case .appleMusic:
            return MusicService(
                id: "apple-music",
                name: "Apple Music",
                isConnected: true,
                iconName: "applelogo",
                serviceType: .appleMusic
            )
        }
    }
}

