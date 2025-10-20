import Swinject

final class MusicServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Clients
        container.register(SpotifyServiceClient.self) { resolver in
            SpotifyServiceClient(errorService: resolver.resolve(ErrorService.self)!)
        }

        container.register(YouTubeMusicServiceClient.self) { resolver in
            YouTubeMusicServiceClient(errorService: resolver.resolve(ErrorService.self)!)
        }

        container.register(AppleMusicServiceClient.self) { resolver in
            AppleMusicServiceClient(errorService: resolver.resolve(ErrorService.self)!)
        }

        // MARK: - Manager
        _ = container.registerMainActor(MusicServiceManager.self) { resolver in
            MusicServiceManager(
                spotifyClient: resolver.resolve(SpotifyServiceClient.self)!,
                youTubeMusicClient: resolver.resolve(YouTubeMusicServiceClient.self)!,
                appleMusicClient: resolver.resolve(AppleMusicServiceClient.self)!,
                errorService: resolver.resolve(ErrorService.self)!,
                notificationService: resolver.resolve(NotificationService.self)!
            )
        }
    }
}

