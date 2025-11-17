import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isUserAuthenticated = false
    @Published var shouldShowAuthButtons = false
    @Published var shouldProceedToMain = false
    
    private let authManager: AuthManager
    private let errorHandler: ErrorHandler
    private let loadingService: LoadingService
    private var cancellables = Set<AnyCancellable>()
    
    init(authManager: AuthManager, errorHandler: ErrorHandler, loadingService: LoadingService) {
        self.authManager = authManager
        self.errorHandler = errorHandler
        self.loadingService = loadingService
        setupAuthObservers()
    }
    
    func checkAuthentication() {
        Task {
            await performOperation(
                context: "session_check",
                operation: {
                    try await authManager.restoreLastSession()
                },
                errorContext: "Session Restore"
            )
        }
    }
    
    func handleSplashCompletion() {
        guard !loadingService.isLoading else { return }
        
        if isUserAuthenticated {
            shouldProceedToMain = true
        } else {
            shouldShowAuthButtons = true
        }
    }
    
    func signInWithGoogle() async {
        await performOperation(
            context: "google_auth",
            operation: {
                guard self.isGoogleSignInAvailable() else {
                    throw AppError.auth(.unsupportedProvider)
                }
                
                try await authManager.signInWithGoogle()
            },
            errorContext: "Google Sign In"
        )
    }
    
    func signInWithApple() async {
        await performOperation(
            context: "apple_auth",
            operation: {
                guard self.isAppleSignInAvailable() else {
                    throw AppError.auth(.unsupportedProvider)
                }
                
                try await authManager.signInWithApple()
            },
            errorContext: "Apple Sign In"
        )
    }
    
    // MARK: - Private Helpers
    
    private func performOperation(
        context: String,
        operation: () async throws -> Void,
        errorContext: String
    ) async {
        loadingService.setLoading(true, context: context)
        defer { loadingService.setLoading(false, context: context) }
        
        do {
            try await operation()
        } catch {
            errorHandler.handle(error, context: errorContext)
        }
    }
    
    private func setupAuthObservers() {
        authManager.$isUserLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.isUserAuthenticated = isLoggedIn
                if isLoggedIn {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self?.shouldProceedToMain = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func isGoogleSignInAvailable() -> Bool {
        // Тут може бути логіка перевірки налаштування Google Services
        return true
    }
    
    private func isAppleSignInAvailable() -> Bool {
        // Перевірка доступності Sign in with Apple
        return true
    }
}
