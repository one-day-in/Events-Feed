import Foundation
import Combine

protocol MusicServiceManagerProtocol: ObservableObject {
    var musicServices: [MusicService] { get }
    var isSpotifyConnected: Bool { get }
    var isYouTubeMusicConnected: Bool { get }
    func connectSpotify()
    func disconnectSpotify()
    func connectYouTubeMusic()
    func disconnectYouTubeMusic()
    func updateMusicServices()
}

final class MusicServiceManager: MusicServiceManagerProtocol {
    @Published var musicServices: [MusicService] = []
    
    private let spotifyClient: SpotifyServiceClient
    private let youTubeMusicClient: YouTubeMusicServiceClient
    private let errorService: ErrorService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        spotifyClient: SpotifyServiceClient = SpotifyServiceClient(),
        youTubeMusicClient: YouTubeMusicServiceClient = YouTubeMusicServiceClient(),
        errorService: ErrorService = .shared
    ) {
        self.spotifyClient = spotifyClient
        self.youTubeMusicClient = youTubeMusicClient
        self.errorService = errorService
        setupSpotifyObservers()
        setupYouTubeMusicObservers()
        updateMusicServices()
    }
        
    func updateMusicServices() {
        var updatedServices: [MusicService] = []
        
        if spotifyClient.isAuthenticated() {
            updatedServices.append(MusicService(
                id: "spotify",
                name: "Spotify",
                isConnected: true,
                iconName: "spotify",
                serviceType: .spotify
            ))
        }
        
        if youTubeMusicClient.isAuthenticated() {
            updatedServices.append(MusicService(
                id: "youtube-music",
                name: "YouTube Music",
                isConnected: true,
                iconName: "play.circle.fill",
                serviceType: .youtubeMusic
            ))
        }
        
        musicServices = updatedServices
    }
    
    private func setupSpotifyObservers() {
        NotificationCenter.default.publisher(for: .spotifyAuthSuccess)
            .sink { [weak self] _ in
                self?.updateMusicServices()
            }
            .store(in: &cancellables)
            
        NotificationCenter.default.publisher(for: .spotifyAuthError)
            .sink { [weak self] notification in
                if let error = notification.object as? String {
                    self?.errorService.reportSpotifyError(error)
                }
            }
            .store(in: &cancellables)
            
        NotificationCenter.default.publisher(for: .spotifyDisconnected)
            .sink { [weak self] _ in
                self?.updateMusicServices()
            }
            .store(in: &cancellables)
    }
    
    private func setupYouTubeMusicObservers() {
        NotificationCenter.default.publisher(for: .youtubeMusicAuthSuccess)
            .sink { [weak self] _ in
                self?.updateMusicServices()
            }
            .store(in: &cancellables)
            
        NotificationCenter.default.publisher(for: .youtubeMusicAuthError)
            .sink { [weak self] notification in
                if let error = notification.object as? String {
                    self?.errorService.reportYouTubeMusicError(error)
                }
            }
            .store(in: &cancellables)
            
        NotificationCenter.default.publisher(for: .youtubeMusicDisconnected)
            .sink { [weak self] _ in
                self?.updateMusicServices()
            }
            .store(in: &cancellables)
    }
}

extension MusicServiceManager {
    var isSpotifyConnected: Bool {
        return spotifyClient.isAuthenticated()
    }
    
    func connectSpotify() {
        spotifyClient.authenticate()
    }
    
    func disconnectSpotify() {
        spotifyClient.disconnect()
        updateMusicServices()
    }
}

extension MusicServiceManager {
    var isYouTubeMusicConnected: Bool {
        return youTubeMusicClient.isAuthenticated()
    }
    
    func connectYouTubeMusic() {
        youTubeMusicClient.authenticate()
    }
    
    func disconnectYouTubeMusic() {
        youTubeMusicClient.disconnect()
        updateMusicServices()
    }
}
