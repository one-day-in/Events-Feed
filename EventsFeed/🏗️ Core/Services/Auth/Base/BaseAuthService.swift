import Foundation

protocol AuthServiceProtocol {
    func signIn() async throws -> User
    func signOut() throws
    func restoreSession() async throws -> User?
    func getAccessToken() async throws -> String?
    func handle(_ url: URL) -> Bool
}

// MARK: - Base Auth Service
class BaseAuthService: NSObject, AuthServiceProtocol {
    let provider: AuthProvider
    
    init(provider: AuthProvider) {
        self.provider = provider
        super.init()
    }
    
    // MARK: - AuthServiceProtocol
    func signIn() async throws -> User {
        fatalError("Must be implemented by subclass")
    }
    
    func signOut() throws {
        // Базова реалізація - нічого не робить
        // Субкласи можуть перевизначити для специфічного cleanup
    }
    
    func restoreSession() async throws -> User? {
        fatalError("Must be implemented by subclass")
    }
    
    func getAccessToken() async throws -> String? {
        // Базова реалізація - повертає nil
        // Субкласи для провайдерів з токенами перевизначать
        return nil
    }
    
    func handle(_ url: URL) -> Bool {
        return false
    }
    
    // MARK: - Helpers
    func performAuthOperation<T>(_ operation: () async throws -> T) async throws -> T {
        try await operation()
    }
}
