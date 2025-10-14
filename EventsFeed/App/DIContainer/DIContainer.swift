import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        
        assembler = Assembler([
            CoreAssembly(),           // Базові сервіси та UI
            AuthenticationAssembly(), // Аутентифікація (Google + Apple)
            MusicServicesAssembly(),  // Музичні сервіси
            ManagersAssembly(),       // Менеджери високого рівня
            ViewModelsAssembly() 
        ], container: container)
        print("✅ DI Container ініціалізовано")
    }
        
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(T.self) else {
            fatalError("Помилка резолву залежності для типу \(String(describing: T.self))")
        }
        return dependency
    }
}

// MARK: - Main Actor Registration Extension
extension Container {
    /// Реєстрація залежності, яка повинна створюватися на головному акторі
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
