import Foundation
import UIKit

// Спрощений клієнт YouTube Music, що успадковує базовий
final class YouTubeMusicServiceClient: BaseMusicServiceClient<
    YouTubeMusicConstants,
    YouTubeMusicWebAuthHandler,
    YouTubeMusicTokenStorage
> {
    
    override init(
        webAuthHandler: YouTubeMusicWebAuthHandler,
        tokenStorage: YouTubeMusicTokenStorage,
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
        let authHandler = YouTubeMusicWebAuthHandler()
        let tokenStorage = YouTubeMusicTokenStorage()
        
        self.init(
            webAuthHandler: authHandler,
            tokenStorage: tokenStorage,
            errorService: errorService,
            serviceType: .youtubeMusic
        )
    }
    
    // Додаткові методи специфічні для YouTube Music API
    func getUserListeningHistory(completion: @escaping (Result<[YouTubeMusicHistoryItem], Error>) -> Void) {
        guard getAccessToken() != nil else {
            completion(.failure(MusicServiceAuthError.noAccessToken))
            return
        }
        
        // Тут буде реалізація запиту до YouTube Music API
        completion(.success([]))
    }
    
    func getUserLikedMusic(completion: @escaping (Result<[YouTubeMusicTrack], Error>) -> Void) {
        guard getAccessToken() != nil else {
            completion(.failure(MusicServiceAuthError.noAccessToken))
            return
        }
        
        // Тут буде реалізація запиту до YouTube Music API
        completion(.success([]))
    }
}

// Моделі даних YouTube Music (можна перенести з оригінального файлу)
struct YouTubeMusicHistoryItem: Codable, Identifiable {
    let id: String
    let title: String
    let artist: String
    let playedAt: Date
    let duration: TimeInterval
}

struct YouTubeMusicTrack: Codable, Identifiable {
    let id: String
    let title: String
    let artist: String
    let album: String?
    let duration: TimeInterval
    let thumbnails: [YouTubeThumbnail]
}

struct YouTubeThumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
}
