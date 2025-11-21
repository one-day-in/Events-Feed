
final class ManagersAssembly: AppAssembly {
    func register(in container: DIContainer) {
        // MARK: - AuthManager
        container.register(AuthManager.self) { resolver in
            let authClient = resolver.resolve(AuthClient.self)!
            return AuthManager(authClient: authClient)
        }
        
        container.register(MusicServiceManager.self) { resolver in
            let clients: [MusicServiceType: MusicProviderClient] = [
                .spotify: resolver.resolve(MusicProviderClient.self, name: "spotify")!,
                .youtubeMusic: resolver.resolve(MusicProviderClient.self, name: "youtube")!,
                .appleMusic: resolver.resolve(MusicProviderClient.self, name: "apple")!
            ]
            return MusicServiceManager(clients: clients)
        }
    }
}
