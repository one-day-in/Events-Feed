import SwiftUI
import Combine

@MainActor
final class AuthManager: ObservableObject {
    
    // MARK: - Published State
    @Published private(set) var currentUser: User?
    @Published private(set) var isUserLoggedIn: Bool = false
    
    // MARK: - Services
    private let googleAuthService: GoogleAuthService
    private let appleAuthService: AppleAuthService
    
    // MARK: - Storage
    private let userDefaults: UserDefaults
    private let lastActiveProviderKey = "lastActiveAuthProvider"
    
    // MARK: - Initialization
    init(
        googleAuthService: GoogleAuthService,
        appleAuthService: AppleAuthService,
        userDefaults: UserDefaults = .standard
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public API
    func handleAuthCallback(_ url: URL) -> Bool {
        googleAuthService.handle(url)
    }
}

// MARK: - Google Auth
extension AuthManager {
    func signInWithGoogle() async throws {
        let user = try await googleAuthService.signIn()
        await updateAuthState(user: user, provider: .google)
        print("✅ Google Sign-In successful:", user.name ?? "No name")
    }
}

// MARK: - Session Management
extension AuthManager {
    func restoreLastSession() async throws {
        if let provider = getActiveProvider() {
            let user: User?
            
            switch provider {
            case .google:
                user = try await googleAuthService.restoreSession()
            case .apple:
                user = try await appleAuthService.restoreSession()
            }
            
            if let user = user {
                await updateAuthState(user: user, provider: provider)
                print("🔐 Session restored for:", user.name ?? "No name")
            } else {
                // Немає активної сесії - це нормально
                await updateAuthState(user: nil, provider: nil)
                print("🔐 No active session found")
            }
        }
    }
    
    func signOut() throws {
        if let provider = getActiveProvider() {
            switch provider {
            case .google:
                try googleAuthService.signOut()
            case .apple:
                try appleAuthService.signOut()
            }
        }
        Task {
            await updateAuthState(user: nil, provider: nil)
        }
    }
}

// MARK: - Private Methods
private extension AuthManager {
    func updateAuthState(user: User?, provider: AuthProvider?) async {
        self.currentUser = user
        self.isUserLoggedIn = user != nil
        
        if let provider = provider {
            saveLastProvider(provider)
        } else {
            clearLastProvider()
        }
    }
    
    func saveLastProvider(_ provider: AuthProvider) {
        userDefaults.set(provider.rawValue, forKey: lastActiveProviderKey)
    }
    
    func getActiveProvider() -> AuthProvider? {
        guard let rawValue = userDefaults.string(forKey: lastActiveProviderKey) else { return nil }
        return AuthProvider(rawValue: rawValue)
    }
    
    func clearLastProvider() {
        userDefaults.removeObject(forKey: lastActiveProviderKey)
    }
}
