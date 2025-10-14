import Swinject

final class AuthenticationAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Authentication Services
        container.registerMainActor(AppleAuthService.self) { resolver in
            let errorService = resolver.resolve(ErrorService.self)!
            return AppleAuthService(errorService: errorService)
        }.inObjectScope(.container)
        
        container.registerMainActor(GoogleAuthService.self) { _ in
            return GoogleAuthService()
        }.inObjectScope(.container)
        
        // MARK: - Auth Manager
        container.registerMainActor(AuthManager.self) { resolver in
            let googleAuth = resolver.resolve(GoogleAuthService.self)!
            let appleAuth = resolver.resolve(AppleAuthService.self)!
            return AuthManager(
                googleAuthService: googleAuth,
                appleAuthService: appleAuth
            )
        }.inObjectScope(.container)
        
        container.register((any AuthServiceProtocol).self) { resolver in
            return resolver.resolve(AuthManager.self)!
        }.inObjectScope(.container)
    }
}
