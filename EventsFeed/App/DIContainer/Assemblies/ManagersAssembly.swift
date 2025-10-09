import Foundation
import Swinject

final class ManagersAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - Music Services Manager
        container.register(MusicServiceManager.self) { resolver in
            let spotifyClient = resolver.resolve(SpotifyServiceClient.self)!
            let youTubeMusicClient = resolver.resolve(YouTubeMusicServiceClient.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            return MusicServiceManager(
                spotifyClient: spotifyClient,
                youTubeMusicClient: youTubeMusicClient,
                errorService: errorService
            )
        }.inObjectScope(.container)
        
        container.register((any MusicServiceManagerProtocol).self) { resolver in
            return resolver.resolve(MusicServiceManager.self)!
        }.inObjectScope(.container)

        // MARK: - Main Coordinator
        container.register(CoordinatedSessionManager.self) { resolver in
            let userSessionManager = resolver.resolve((any UserSessionManagerProtocol).self)!
            let musicServiceManager = resolver.resolve(MusicServiceManager.self)!
            return CoordinatedSessionManager(
                userSessionManager: userSessionManager,
                musicServiceManager: musicServiceManager
            )
        }.inObjectScope(.container)
    }
}
