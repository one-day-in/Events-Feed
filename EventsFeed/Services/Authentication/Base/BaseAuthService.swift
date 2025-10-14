import Foundation
import Combine

@MainActor
class BaseAuthService: NSObject, ObservableObject, AuthServiceProtocol {
    @Published private(set) var isUserLoggedIn: Bool = false
    @Published private(set) var currentUser: User? = nil
    @Published private(set) var isLoading: Bool = false
    
    // Оновлений метод з параметрами
    func signIn(with options: AuthSignInOptions?) async throws -> User {
        fatalError("Must be implemented by subclass")
    }

    func signOut() throws {
        currentUser = nil
        isUserLoggedIn = false
    }
    
    func restoreSession() async {
        // Базова реалізація
    }
    
    func handle(_ url: URL) -> Bool {
        return false
    }
    
    // Загальні утиліти
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    func updateUser(_ user: User?, isLoggedIn: Bool) {
        currentUser = user
        isUserLoggedIn = isLoggedIn
    }
    
    func performAuthOperation<T>(_ operation: () async throws -> T) async throws -> T {
        setLoading(true)
        defer { setLoading(false) }
        return try await operation()
    }
}
