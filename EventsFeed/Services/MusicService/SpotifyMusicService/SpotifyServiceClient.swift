import Foundation
import UIKit

// Спрощений клієнт Spotify, що успадковує базовий
final class SpotifyServiceClient: BaseMusicServiceClient<
    SpotifyConstants,
    SpotifyWebAuthHandler,
    SpotifyTokenStorage
> {
    
    override init(
        webAuthHandler: SpotifyWebAuthHandler,
        tokenStorage: SpotifyTokenStorage,
        errorService: ErrorService,
        serviceType: MusicServiceType
    ) {
        super.init(
            webAuthHandler: webAuthHandler,
            tokenStorage: tokenStorage,
            errorService: errorService,
            serviceType: serviceType
        )
    }
    
    convenience init(errorService: ErrorService = .shared) {
        let authHandler = SpotifyWebAuthHandler()
        let tokenStorage = SpotifyTokenStorage()
        
        self.init(
            webAuthHandler: authHandler,
            tokenStorage: tokenStorage,
            errorService: errorService,
            serviceType: .spotify
        )
    }
    
    // Додаткові методи специфічні для Spotify API
    func getUserTopTracks(completion: @escaping (Result<[SpotifyTrack], Error>) -> Void) {
        guard getAccessToken() != nil else {
            completion(.failure(MusicServiceAuthError.noAccessToken))
            return
        }
        
        // Тут буде реалізація запиту до Spotify API
        completion(.success([]))
    }
}

// Моделі даних Spotify
struct SpotifyTrack: Codable, Identifiable {
    let id: String
    let name: String
    let artist: String
    let album: String?
    let duration: TimeInterval
    let previewUrl: String?
}
