import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.registerMainActor(ErrorHandler.self) { _ in
            return ErrorHandler()
        }
        .inObjectScope(.container)
                
        container.registerMainActor(LoadingService.self) { _ in
            return LoadingService()
        }
        .inObjectScope(.container)
    }
}
