import Foundation
import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Foundation Services
        container.register(ErrorService.self) { _ in
            return ErrorService.shared
        }.inObjectScope(.container)
        
        // MARK: - Content Services
        container.register(ConcertServiceProtocol.self) { _ in
            return ConcertService()
        }.inObjectScope(.container)
        
        // MARK: - UI Managers
        container.registerMainActor(LoadingAnimationManager.self) { _ in
            return LoadingAnimationManager()
        }.inObjectScope(.transient)
    }
}
