import Swinject

final class DIContainer {
    private let container: Container = Container()

    init(assemblies: [AppAssembly] = []) {

        // ⚠️ Спочатку реєструємо звичайні сервіси
        assemblies.forEach { $0.register(in: self) }

        #if DEBUG
        // Sanity-check: critical dependencies must exist
        _ = resolveSafe(ErrorHandler.self)
        _ = resolveSafe(LoadingService.self)
        #endif
    }

    // MARK: - Standard registration
    func register<T>(_ type: T.Type, name: String? = nil, factory: @escaping (Resolver) -> T) {
        container.register(type, name: name, factory: factory)
    }

    // MARK: - Singleton registration
    func registerSingleton<T>(_ type: T.Type, instance: T, name: String? = nil) {
        container.register(type, name: name) { _ in instance }
    }

    // MARK: - Resolve
    func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        guard let dependency = container.resolve(type, name: name) else {
            fatalError("⚠️ Missing dependency: \(T.self)")
        }
        return dependency
    }

    func resolveSafe<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }

    var swinject: Container { container }
}
