import Foundation
import Combine

@MainActor
final class AuthManager: ObservableObject, AuthServiceProtocol {
    // MARK: - Published Properties
    @Published private(set) var isUserLoggedIn: Bool = false
    @Published private(set) var currentUser: User? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var currentProvider: AuthProvider = .google
    
    // MARK: - Dependencies
    private let googleAuthService: GoogleAuthService
    private let appleAuthService: AppleAuthService
    private let errorService: ErrorService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        googleAuthService: GoogleAuthService,
        appleAuthService: AppleAuthService,
        errorService: ErrorService = .shared
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.errorService = errorService
        setupBindings()
    }
    
    // MARK: - AuthServiceProtocol Methods
    
    /// ✅ Реалізація вимоги протоколу
    func signIn(with options: AuthSignInOptions?) async throws -> User {
        // Викликаємо метод нижче з поточним провайдером
        try await signIn(with: currentProvider, options: options)
    }
    
    func signOut() throws {
        do {
            switch currentProvider {
            case .google:
                try googleAuthService.signOut()
            case .apple:
                try appleAuthService.signOut()
            }
            isUserLoggedIn = false
            currentUser = nil
        } catch {
            errorService.reportAuthError(
                "Sign-out failed: \(error.localizedDescription)",
                context: "[AuthManager:\(currentProvider)]"
            )
            throw error
        }
    }
    
    func restoreSession() async {
        await googleAuthService.restoreSession()
        await appleAuthService.restoreSession()
    }
    
    func handle(_ url: URL) -> Bool {
        googleAuthService.handle(url) || appleAuthService.handle(url)
    }
    
    // MARK: - Extended Logic
    
    /// Додатковий метод для явного вибору провайдера
    func signIn(with provider: AuthProvider, options: AuthSignInOptions? = nil) async throws -> User {
        do {
            let user = try await {
                switch provider {
                case .google:
                    return try await googleAuthService.signIn(with: options)
                case .apple:
                    return try await appleAuthService.signIn(with: options)
                }
            }()
            
            currentProvider = provider
            return user
            
        } catch {
            errorService.reportAuthError(
                "Sign-in failed: \(error.localizedDescription)",
                context: "[AuthManager:\(provider)]"
            )
            throw error
        }
    }
    
    // MARK: - Private Bindings
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
                self.currentUser = provider == .google
                    ? self.googleAuthService.currentUser
                    : self.appleAuthService.currentUser
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
