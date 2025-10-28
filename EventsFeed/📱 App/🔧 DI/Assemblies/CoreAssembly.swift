import Foundation
import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CoreErrorService.self) { _ in
            return CoreErrorService()
        }
        .inObjectScope(.container)
        
        container.registerMainActor(UIErrorService.self) { resolver in
            let coreErrorService = resolver.resolve(CoreErrorService.self)!
            return UIErrorService(coreService: coreErrorService)
        }
        .inObjectScope(.container)
        
        container.registerMainActor(LoadingService.self) { _ in
            return LoadingService()
        }
        .inObjectScope(.container)
    }
}
