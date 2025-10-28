import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Auth Providers
        container.registerMainActor(GoogleAuthService.self) { _ in
            return GoogleAuthService()
        }
        .inObjectScope(.container)
        
        container.registerMainActor(AppleAuthService.self) { _ in
            return AppleAuthService(provider: AuthProvider.apple)
        }
        .inObjectScope(.container)
        
        // MARK: - Spotify
        container.registerMainActor(SpotifyServiceClient.self) { _ in
            return SpotifyServiceClient()
        }
        .inObjectScope(.container)
        
        // MARK: - YouTube Music
        container.registerMainActor(YouTubeMusicServiceClient.self) { _ in
            return YouTubeMusicServiceClient()
        }
        .inObjectScope(.container)
        
        // MARK: - Apple Music
        container.registerMainActor(AppleMusicServiceClient.self) { _ in
            return AppleMusicServiceClient()
        }
        .inObjectScope(.container)
    }
}
