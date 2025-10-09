import Foundation

protocol AuthServiceProtocol: AnyObject {
    var isUserLoggedIn: Bool { get }
    var currentUser: User? { get }
    
    func signIn() async throws -> User
    func signOut() throws
    func restoreSession() async
    
    func handle(_ url: URL) -> Bool
}

protocol UserSessionManagerProtocol: ObservableObject {
    var isLoggedIn: Bool { get }
    var currentUser: User? { get }
    var isLoading: Bool { get }
    func restoreSession() async
    func signIn() async
    func signOut()
}
