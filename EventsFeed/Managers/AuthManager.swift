import Foundation
import Combine

@MainActor
final class AuthManager: ObservableObject, AuthServiceProtocol {
    @Published private(set) var isUserLoggedIn: Bool = false
    @Published private(set) var currentUser: User? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var currentProvider: AuthProvider = .google
    
    private let googleAuthService: GoogleAuthService
    private let appleAuthService: AppleAuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(googleAuthService: GoogleAuthService, appleAuthService: AppleAuthService) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        setupBindings()
    }
    
    func signIn(with options: AuthSignInOptions?) async throws -> User {
        return try await signIn(with: currentProvider, options: options)
    }
    
    func signIn(with provider: AuthProvider, options: AuthSignInOptions? = nil) async throws -> User {
         do {
             let user = try await {
                 switch provider {
                 case .google:
                     return try await googleAuthService.signIn(with: options)
                 case .apple:
                     return try await appleAuthService.signIn(with: nil)
                 }
             }()
             
             currentProvider = provider
             return user
             
         } catch {
             print("Sign in failed for \(provider): \(error)")
             throw error
         }
     }
    
    func signOut() throws {
        switch currentProvider {
        case .google:
            try googleAuthService.signOut()
        case .apple:
            try appleAuthService.signOut()
        }
        isUserLoggedIn = false
        currentUser = nil
    }
        
    func restoreSession() async {
        await googleAuthService.restoreSession()
        await appleAuthService.restoreSession()
    }
    
    func handle(_ url: URL) -> Bool {
        return googleAuthService.handle(url) || appleAuthService.handle(url)
    }
    
    private func setupBindings() {
        Publishers.Merge(
            googleAuthService.$isUserLoggedIn
                .map { (provider: AuthProvider.google, isLoggedIn: $0) },
            appleAuthService.$isUserLoggedIn
                .map { (provider: AuthProvider.apple, isLoggedIn: $0) }
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] provider, isLoggedIn in
            guard let self = self else { return }
            
            if isLoggedIn {
                self.currentProvider = provider
                switch provider {
                case .google:
                    self.currentUser = self.googleAuthService.currentUser
                case .apple:
                    self.currentUser = self.appleAuthService.currentUser
                }
                self.isUserLoggedIn = true
            } else if self.currentProvider == provider {
                self.isUserLoggedIn = false
                self.currentUser = nil
            }
        }
        .store(in: &cancellables)
        
        Publishers.CombineLatest(
            googleAuthService.$isLoading,
            appleAuthService.$isLoading
        )
        .receive(on: RunLoop.main)
        .map { $0 || $1 }
        .assign(to: &$isLoading)
    }
}

enum AuthProvider {
    case google, apple
}
