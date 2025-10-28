import Swinject

final class ManagersAssembly: Assembly {
    func assemble(container: Container) {        
        // MARK: - AuthManager
        container.registerMainActor(AuthManager.self) { resolver in
            AuthManager(
                googleAuthService: resolver.resolve(GoogleAuthService.self)!,
                appleAuthService: resolver.resolve(AppleAuthService.self)!,
            )
        }
        .inObjectScope(.container)
        
        // MARK: - MusicServiceManager
        container.registerMainActor(MusicServiceManager.self) { resolver in
            MusicServiceManager(
                spotifyClient: resolver.resolve(SpotifyServiceClient.self)!,
                youtubeClient: resolver.resolve(YouTubeMusicServiceClient.self)!,
                appleMusicClient: resolver.resolve(AppleMusicServiceClient.self)!
            )
        }
        .inObjectScope(.container)
    }
}
