import Foundation
import Swinject

final class MusicServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Music Service Clients
        container.register(SpotifyServiceClient.self) { resolver in
            let errorService = resolver.resolve(ErrorService.self)!
            return SpotifyServiceClient(errorService: errorService)
        }.inObjectScope(.container)
        
        container.register(YouTubeMusicServiceClient.self) { resolver in
            let errorService = resolver.resolve(ErrorService.self)!
            return YouTubeMusicServiceClient(errorService: errorService)
        }.inObjectScope(.container)
        
        container.register(AppleMusicServiceClient.self) { resolver in
            let errorService = resolver.resolve(ErrorService.self)!
            return AppleMusicServiceClient(errorService: errorService)
        }.inObjectScope(.container)
        
        // MARK: - Music Service Manager
        container.registerMainActor(MusicServiceManager.self) { resolver in
            let spotifyClient = resolver.resolve(SpotifyServiceClient.self)!
            let youTubeMusicClient = resolver.resolve(YouTubeMusicServiceClient.self)!
            let appleMusicClient = resolver.resolve(AppleMusicServiceClient.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            return MusicServiceManager(
                spotifyClient: spotifyClient,
                youTubeMusicClient: youTubeMusicClient,
                appleMusicClient: appleMusicClient,
                errorService: errorService
            )
        }.inObjectScope(.container)
    }
}
