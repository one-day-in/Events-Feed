import Swinject

final class ManagersAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - AuthManager
        container.register(AuthManager.self) { resolver in
            let authClient = resolver.resolve(AuthClient.self)!
            return AuthManager(authClient: authClient)
        }
        .inObjectScope(.container)
        
        // MARK: - MusicServiceManager
        container.register(MusicServiceManager.self) { resolver in
            let context = resolver.resolve(PresentationContextProviding.self)!
            let tokenStorage = resolver.resolve(TokenStorageProtocol.self)!

            let clients: [MusicServiceType: MusicServiceClient] = [
                .spotify: MusicServiceClient(
                    serviceType: .spotify,
                    tokenStorage: tokenStorage,
                    context: context
                ),
                .youtubeMusic: MusicServiceClient(
                    serviceType: .youtubeMusic,
                    tokenStorage: tokenStorage,
                    context: context
                ),
                .appleMusic: MusicServiceClient(
                    serviceType: .appleMusic,
                    tokenStorage: tokenStorage,
                    context: context
                )
            ]

            return MusicServiceManager(clients: clients)
        }
        .inObjectScope(.container)

    }
}
