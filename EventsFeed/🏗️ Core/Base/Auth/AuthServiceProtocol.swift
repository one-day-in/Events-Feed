import Foundation

@MainActor
protocol AuthServiceProtocol: ObservableObject {
    var isUserLoggedIn: Bool { get }
    var currentUser: User? { get }
    var isLoading: Bool { get }
    
    func signIn(with options: AuthSignInOptions?) async throws -> User
    func signOut() throws
    func restoreSession() async
    func handle(_ url: URL) -> Bool
}
