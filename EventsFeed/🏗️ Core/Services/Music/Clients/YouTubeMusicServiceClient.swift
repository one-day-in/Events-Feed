import Foundation

@MainActor
final class YouTubeMusicServiceClient: BaseMusicServiceClient<
    YouTubeMusicConstants,
    YouTubeMusicWebAuthHandler,
    YouTubeMusicTokenStorage
> {
    convenience init(errorService: ErrorService = .shared) {
        self.init(
            webAuthHandler: YouTubeMusicWebAuthHandler(),
            tokenStorage: YouTubeMusicTokenStorage(),
            errorService: errorService,
            serviceType: .youtubeMusic
        )
    }
}
