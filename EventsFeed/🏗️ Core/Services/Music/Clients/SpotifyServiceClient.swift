import Foundation

@MainActor
final class SpotifyServiceClient: BaseMusicServiceClient<
    SpotifyConstants,
    SpotifyWebAuthHandler,
    SpotifyTokenStorage
> {
    convenience init(errorService: ErrorService = .shared) {
        self.init(
            webAuthHandler: SpotifyWebAuthHandler(),
            tokenStorage: SpotifyTokenStorage(),
            errorService: errorService,
            serviceType: .spotify
        )
    }
}
