import Swinject

final class ManagersAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - AuthManager
        container.register(AuthManager.self) { resolver in
            let authClient = resolver.resolve(AuthClient.self)!
            return AuthManager(authClient: authClient)
        }
        .inObjectScope(.container)
        
        container.register(MusicServiceManager.self) { resolver in
            let clients: [MusicServiceType: MusicProviderClient] = [
                .spotify: resolver.resolve(MusicProviderClient.self, name: "spotify")!,
                .youtubeMusic: resolver.resolve(MusicProviderClient.self, name: "youtube")!,
                .appleMusic: resolver.resolve(MusicProviderClient.self, name: "apple")!
            ]
            return MusicServiceManager(clients: clients)
        }.inObjectScope(.container)
    }
}
