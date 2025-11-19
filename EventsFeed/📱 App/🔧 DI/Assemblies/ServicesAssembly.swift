import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Auth Providers
        container.register(AuthClient.self) { _ in
            AuthClient()
        }
        .inObjectScope(.container)
        
        container.register(ApiClient.self) { _ in
            ApiClient()
        }
        .inObjectScope(.container)
        
        container.register(ConcertService.self) { resolver in
            let apiClient = resolver.resolve(ApiClient.self)!
            return ConcertService(apiClient: apiClient)
        }
        .inObjectScope(.container)
        
        container.register(MusicProviderClient.self) { resolver, service in
            let storage = resolver.resolve(MusicServiceTokenStore.self)!
            let oAuth = resolver.resolve(OAuthFlow.self)!
            return MusicProviderClient(service: service, storage: storage, oAuth: oAuth)
        }
        .inObjectScope(.transient)
        
        container.register(MusicProviderClient.self, name: "spotify") { resolver in
            MusicProviderClient(
                service: .spotify,
                storage: resolver.resolve(MusicServiceTokenStore.self)!,
                oAuth: resolver.resolve(OAuthFlow.self)!
            )
        }
        
        container.register(MusicProviderClient.self, name: "youtube") { resolver in
            MusicProviderClient(
                service: .youtubeMusic,
                storage: resolver.resolve(MusicServiceTokenStore.self)!,
                oAuth: resolver.resolve(OAuthFlow.self)!
            )
        }
        
        container.register(MusicProviderClient.self, name: "apple") { resolver in
            MusicProviderClient(
                service: .appleMusic,
                storage: resolver.resolve(MusicServiceTokenStore.self)!,
                oAuth: resolver.resolve(OAuthFlow.self)!
            )
        }
    }
}
