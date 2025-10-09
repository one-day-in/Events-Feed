import Foundation
import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        
        assembler = Assembler([
            FoundationAssembly(),
            AuthenticationAssembly(),
            SpotifyAssembly(),
            YouTubeMusicAssembly(),
            ManagersAssembly(),
            ViewModelsAssembly()
        ], container: container)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(T.self) else {
            fatalError("Помилка резолву залежності для типу \(String(describing: T.self))")
        }
        return dependency
    }
}
