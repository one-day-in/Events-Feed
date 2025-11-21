
final class ServicesAssembly: AppAssembly {
    func register(in container: DIContainer) {

        container.register(AuthClient.self) { _ in AuthClient() }
        container.register(ApiClient.self) { _ in ApiClient() }

        container.register(ConcertService.self) { resolver in
            ConcertService(apiClient: resolver.resolve(ApiClient.self)!)
        }

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
