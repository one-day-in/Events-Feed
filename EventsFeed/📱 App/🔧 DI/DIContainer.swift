import Foundation
import Swinject

final class DIContainer {
    private let container: Container
    private let assembler: Assembler
    
    init() {
        self.container = Container()
        assembler = Assembler([
            CoreAssembly(),
            ServicesAssembly(),
            ManagersAssembly(),
        ], container: container)
    }
    
    // MARK: - Стандартне resolve (обов'язкове)
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(T.self) else {
            assertionFailure("⚠️ Dependency not found for \(T.self)")
            fatalError("❌ Missing dependency registration: \(T.self)")
        }
        return dependency
    }
}

// MARK: - Main Actor Registration Extension
extension Container {
    func registerMainActor<T>(
        _ serviceType: T.Type,
        name: String? = nil,
        factory: @escaping @MainActor (Resolver) -> T
    ) -> ServiceEntry<T> {
        return self.register(serviceType, name: name) { resolver in
            return MainActor.assumeIsolated {
                factory(resolver)
            }
        }
    }
}
