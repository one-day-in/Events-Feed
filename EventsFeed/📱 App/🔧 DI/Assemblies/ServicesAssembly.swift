import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Auth Providers
        container.register(AuthClient.self) { resolver in
            let presentationContextProviding = resolver.resolve(PresentationContextProviding.self)!
            return AuthClient(context: presentationContextProviding)
        }
        .inObjectScope(.container)
        
        
        container.register(SecureTokenStorage.self) { _ in
            SecureTokenStorage(service: "com.oneDayin.music.tokens")
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
