import Foundation

final class YouTubeMusicServiceClient: BaseMusicServiceClient {
    init(
        tokenStorage: TokenStorage = SecureTokenStorage(service: "MusicService")
    ) {
        let constants = YouTubeMusicConstants()
        let handler = YouTubeWebAuthHandler(constants: constants)
        super.init(
            serviceType: .youtubeMusic,
            webAuthHandler: handler,
            tokenStorage: tokenStorage
        )
    }
}
