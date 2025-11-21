import SwiftUI

@main
struct ConcertBox: App {

    @StateObject private var coordinator: AppCoordinator
    private let container: DIContainer

    init() {

        // MARK: - 1. Створення DI контейнера (core/services)
        let di = DIContainer(assemblies: [
            CoreAssembly(),
            ServicesAssembly(),
            ManagersAssembly()
        ])
        self.container = di

        // MARK: - 2. Створюємо @MainActor UI-level сервіси вручну
        let errorHandler = ErrorHandler()
        let loadingService = LoadingService() 

        // MARK: - 3. Реєструємо їх як singleton у DI
        di.registerSingleton(ErrorHandler.self, instance: errorHandler)
        di.registerSingleton(LoadingService.self, instance: loadingService)

        // MARK: - 4. Створюємо ModuleBuilder
        let builder = ModuleBuilder(container: di)

        // MARK: - 5. Створюємо Coordinator
        _coordinator = StateObject(
            wrappedValue: AppCoordinator(builder: builder)
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                content: AnyView(coordinator.rootView()),
                loadingService: container.resolve(LoadingService.self),
                errorHandler: container.resolve(ErrorHandler.self)
            )
        }
    }
}
