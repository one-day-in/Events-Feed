import Swinject

final class ManagersAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - User Manager
        _ = container.registerMainActor(UserManager.self) { resolver in
            UserManager(
                authManager: resolver.resolve(AuthManager.self)!,
                errorService: resolver.resolve(ErrorService.self)!
            )
        }
        
        // MARK: - App State Manager
        _ = container.registerMainActor(AppStateManager.self) { resolver in
            AppStateManager(
                userManager: resolver.resolve(UserManager.self)!,
                musicServiceManager: resolver.resolve(MusicServiceManager.self)!,
                errorService: resolver.resolve(ErrorService.self)!
            )
        }
    }
}
