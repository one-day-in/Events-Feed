import Foundation
import Swinject

final class ManagersAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Session Manager
        container.registerMainActor(SessionManager.self) { resolver in
            let authManager = resolver.resolve(AuthManager.self)!
            let musicServiceManager = resolver.resolve(MusicServiceManager.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            return SessionManager(
                authManager: authManager,
                musicServiceManager: musicServiceManager,
                errorService: errorService
            )
        }.inObjectScope(.container)
        
        // MARK: - App State Manager
        container.registerMainActor(AppStateManager.self) { resolver in
            let sessionManager = resolver.resolve(SessionManager.self)!
            return AppStateManager(sessionManager: sessionManager)
        }.inObjectScope(.container)
    }
}
