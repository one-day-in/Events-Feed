import Foundation
import Swinject
import GoogleSignIn

final class AuthenticationAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Authentication Services
        container.register(AuthServiceProtocol.self) { _ in
            return GoogleAuthService()
        }.inObjectScope(.container)

        container.register((any UserSessionManagerProtocol).self) { resolver in
            let authService = resolver.resolve(AuthServiceProtocol.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            return UserSessionManager(
                authService: authService,
                errorService: errorService
            )
        }.inObjectScope(.container)
    }
}
