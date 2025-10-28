import Foundation

final class SpotifyServiceClient: BaseMusicServiceClient {
    init(
        tokenStorage: TokenStorage = SecureTokenStorage(service: "MusicService")
    ) {
        let constants = SpotifyConstants()
        let handler = SpotifyWebAuthHandler(constants: constants)
        super.init(
            serviceType: .spotify,
            webAuthHandler: handler,
            tokenStorage: tokenStorage
        )
    }
}

