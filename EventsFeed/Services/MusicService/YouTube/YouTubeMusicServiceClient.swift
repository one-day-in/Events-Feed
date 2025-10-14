import Foundation

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


