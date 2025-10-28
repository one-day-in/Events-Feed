import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var shouldShowAuthSelection = false
    @Published var shouldCompleteOnboarding = false
    
    private let authManager: AuthManager
    private let errorService: UIErrorService
    private let loadingService: LoadingService
    private var cancellables = Set<AnyCancellable>()
    
    init(authManager: AuthManager, errorService: UIErrorService, loadingService: LoadingService) {
        self.authManager = authManager
        self.errorService = errorService
        self.loadingService = loadingService
        setupAuthObservers()
        checkExistingSession()
    }
    
    func skipSplashAnimation() {
        shouldShowAuthSelection = !authManager.isUserLoggedIn
    }
    
    func signInWithGoogle() async {
        loadingService.setLoading(true, context: "google_auth")
        defer { loadingService.setLoading(false, context: "google_auth") }
        
        do {
            try await authManager.signInWithGoogle()
        } catch {
            errorService.report(error, context: "Google Sign-In")
        }
    }
    
    func signInWithApple() async {
        loadingService.setLoading(true, context: "apple_auth")
        defer { loadingService.setLoading(false, context: "apple_auth") }
        
        do {
            try await authManager.signInWithGoogle()
        } catch {
            errorService.report(error, context: "Apple Sign-In")
        }
    }
    
    private func checkExistingSession() {
        Task {
            loadingService.setLoading(true, context: "session_restore")
            defer { loadingService.setLoading(false, context: "session_restore") }
            
            do {
                try await authManager.restoreLastSession()
            } catch {
                errorService.report(error, context: "Session Restore")
            }
            
            // 👇 Автоматичний показ кнопок через 3 секунди, якщо користувач не авторизований
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if !self.authManager.isUserLoggedIn && !self.shouldShowAuthSelection {
                    self.shouldShowAuthSelection = true
                }
            }
        }
    }
    
    private func setupAuthObservers() {
        authManager.$isUserLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.handleAuthStateChange(isLoggedIn: isLoggedIn)
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthStateChange(isLoggedIn: Bool) {
        if isLoggedIn {
            shouldCompleteOnboarding = true
            errorService.clearError(ofType: .auth)
        }
    }
}
