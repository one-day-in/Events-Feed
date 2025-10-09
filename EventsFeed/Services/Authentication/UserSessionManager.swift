import Foundation

final class UserSessionManager: UserSessionManagerProtocol {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var isLoading: Bool = true
    
    private let authService: AuthServiceProtocol
    private let errorService: ErrorService
    
    init(authService: AuthServiceProtocol,
         errorService: ErrorService = .shared) {
        self.authService = authService
        self.errorService = errorService
        Task {
            await restoreSession()
        }
    }
    
    func restoreSession() async {
        await MainActor.run { isLoading = true }
        
        await authService.restoreSession()
        
        await MainActor.run {
            let isSignedIn = authService.isUserLoggedIn
            isLoggedIn = isSignedIn
            currentUser = isSignedIn ? authService.currentUser : nil
            isLoading = false
            print("UserSessionManager: Session restored. isLoggedIn: \(isSignedIn)")
        }
    }
    
    func signIn() async {
        await MainActor.run { isLoading = true }
        
        do {
            let user = try await authService.signIn()
            await MainActor.run {
                currentUser = user
                isLoggedIn = true
                isLoading = false
                print("UserSessionManager: User signed in. User ID: \(user.id)")
            }
        } catch {
            errorService.report(error, context: "Google Sign-In")
            await MainActor.run { isLoading = false }
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
            currentUser = nil
            isLoggedIn = false
            print("UserSessionManager: User signed out.")
        } catch {
            errorService.report(error, context: "Sign out")
        }
    }
}
