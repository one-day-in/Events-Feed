import Swinject

final class AuthenticationAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Auth Providers
        _ = container.registerMainActor(GoogleAuthService.self) { resolver in
            GoogleAuthService(errorService: resolver.resolve(ErrorService.self)!)
        }
        
        _ = container.registerMainActor(AppleAuthService.self) { resolver in
            AppleAuthService(errorService: resolver.resolve(ErrorService.self)!)
        }
        
        // MARK: - Auth Manager
        _ = container.registerMainActor(AuthManager.self) { resolver in
            AuthManager(
                googleAuthService: resolver.resolve(GoogleAuthService.self)!,
                appleAuthService: resolver.resolve(AppleAuthService.self)!,
                errorService: resolver.resolve(ErrorService.self)!
            )
        }
    }
}
