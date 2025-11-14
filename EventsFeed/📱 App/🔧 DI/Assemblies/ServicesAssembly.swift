import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Auth Providers
        container.register(AuthClient.self) { _ in
            return AuthClient()
        }
        .inObjectScope(.container)
        
        
        // MARK: - Music Services
        container.register(MusicServiceClient.self, name: "spotify") { _ in
            MusicServiceClient(
                serviceType: .spotify,
                constants: .spotify
            )
        }
        
        container.register(MusicServiceClient.self, name: "youtube") { _ in
            MusicServiceClient(
                serviceType: .youtubeMusic,
                constants: .youtubeMusic
            )
        }
        
        container.register(MusicServiceClient.self, name: "apple") { _ in
            MusicServiceClient(serviceType: .appleMusic)
        }
        
        
        container.register(ApiClient.self) { _ in
            ApiClient()
        }
        .inObjectScope(.container)
        
        container.register(ConcertService.self) { resolver in
            let apiClient = resolver.resolve(ApiClient.self)!
            return ConcertService(apiClient: apiClient)
        }
        .inObjectScope(.container)
    }
}
