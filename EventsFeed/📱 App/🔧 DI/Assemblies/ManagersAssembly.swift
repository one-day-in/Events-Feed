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
            let clients: [MusicServiceType: MusicServiceClient] = [
                .spotify: resolver.resolve(MusicServiceClient.self, name: "spotify")!,
                .youtubeMusic: resolver.resolve(MusicServiceClient.self, name: "youtube")!,
                .appleMusic:resolver.resolve(MusicServiceClient.self, name: "apple")!
            ]
            return MusicServiceManager(clients: clients)
        }
        .inObjectScope(.container)
    }
}
