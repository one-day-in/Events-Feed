import Foundation
import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Core Services
        container.register(ErrorService.self) { _ in
            ErrorService.shared
        }
        .inObjectScope(.container)
        
        container.register(NotificationService.self) { _ in
            NotificationService.shared
        }
        .inObjectScope(.container)
        
        container.register(ConcertServiceProtocol.self) { _ in
            ConcertService()
        }
    }
}
