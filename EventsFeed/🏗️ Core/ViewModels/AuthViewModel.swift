//import SwiftUI
//
//@MainActor
//final class AuthViewModel: BaseViewModel {
//    
//    // MARK: - Dependencies
//    private let sessionManager: SessionManager
//    
//    // MARK: - Published Properties
//    @Published private(set) var isLoggedIn: Bool = false
//    
//    // MARK: - Initialization
//    init(
//        sessionManager: SessionManager,
//        errorService: ErrorService
//    ) {
//        self.sessionManager = sessionManager
//        super.init(errorService: errorService)
//        setupBindings()
//    }
//    
//    // MARK: - Authentication Methods
//    func signIn(with provider: AuthProvider) async {
//        await executeTask {
//            try await self.performSignIn(with: provider)
//        }
//    }
//    
//    func signOut() async {
//        await executeTask {
//            self.sessionManager.signOut()
//        }
//    }
//    
//    // MARK: - Private Methods
//    private func setupBindings() {
//        sessionManager.$isLoggedIn
//            .assign(to: &$isLoggedIn)
//        
//        sessionManager.$currentUser
//            .sink { [weak self] user in
//                self?.objectWillChange.send()
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func performSignIn(with provider: AuthProvider) async throws {
//        await sessionManager.signIn(with: provider)
//    }
//}
