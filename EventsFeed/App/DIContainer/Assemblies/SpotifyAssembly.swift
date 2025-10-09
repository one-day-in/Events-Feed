import Foundation
import Swinject

final class SpotifyAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Spotify Dependencies
        container.register(SpotifyTokenStorage.self) { _ in
            return SpotifyTokenStorage()
        }
        
        container.register(SpotifyWebAuthHandler.self) { _ in
            return SpotifyWebAuthHandler()
        }
        
        container.register(SpotifyServiceClient.self) { resolver in
            let webAuthHandler = resolver.resolve(SpotifyWebAuthHandler.self)!
            let tokenStorage = resolver.resolve(SpotifyTokenStorage.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            
            return SpotifyServiceClient(
                webAuthHandler: webAuthHandler,
                tokenStorage: tokenStorage,
                errorService: errorService,
                serviceType: .spotify
            )
        }.inObjectScope(.container)
    }
}
