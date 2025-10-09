import Foundation
import Swinject

final class YouTubeMusicAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - YouTube Music Dependencies
        container.register(YouTubeMusicTokenStorage.self) { _ in
            return YouTubeMusicTokenStorage()
        }
        
        container.register(YouTubeMusicWebAuthHandler.self) { _ in
            return YouTubeMusicWebAuthHandler()
        }
        
        container.register(YouTubeMusicServiceClient.self) { resolver in
            let webAuthHandler = resolver.resolve(YouTubeMusicWebAuthHandler.self)!
            let tokenStorage = resolver.resolve(YouTubeMusicTokenStorage.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            
            return YouTubeMusicServiceClient(
                webAuthHandler: webAuthHandler,
                tokenStorage: tokenStorage,
                errorService: errorService,
                serviceType: .youtubeMusic
            )
        }.inObjectScope(.container)
    }
}
