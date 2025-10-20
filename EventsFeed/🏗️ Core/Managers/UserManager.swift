import SwiftUI
import Combine

@MainActor
final class UserManager: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var currentUser: User? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var currentAuthProvider: AuthProvider = .google

    // MARK: - Dependencies
    private let authManager: AuthManager
    private let errorService: ErrorService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Events
    let signOutCompleted = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(authManager: AuthManager, errorService: ErrorService) {
        self.authManager = authManager
        self.errorService = errorService
        setupBindings()
        Task { await restoreSession() }
    }

    // MARK: - Auth Methods
    func signIn(with provider: AuthProvider) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let options = AuthSignInOptions(
                presentationContext: UIApplication.shared.rootViewController,
                scopes: nil,
                parameters: nil
            )
            _ = try await authManager.signIn(with: provider, options: options)
        } catch {
        }
    }

    func signOut() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            try authManager.signOut()
            signOutCompleted.send()
        } catch {
            errorService.report(error)
        }
    }

    func restoreSession() async {
        await authManager.restoreSession()
    }

    // MARK: - Bindings
    private func setupBindings() {
        authManager.$isUserLoggedIn
            .assign(to: &$isLoggedIn)
        
        authManager.$currentUser
            .assign(to: &$currentUser)
        
        authManager.$isLoading
            .assign(to: &$isLoading)
        
        authManager.$currentProvider
            .assign(to: &$currentAuthProvider)
    }
}
