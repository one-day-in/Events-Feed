import SwiftUI
import Combine

final class AuthManager: ObservableObject {
    
    // MARK: - Published State
    @Published private(set) var currentUser: User?
    @Published private(set) var isUserLoggedIn: Bool = false
    @Published private(set) var currentProvider: AuthProvider?
    
    // MARK: - Dependencies
    private let authClient: AuthClient
    private let userDefaults: UserDefaults
    private let lastActiveProviderKey = "lastActiveAuthProvider"
    
    // MARK: - Initialization
    init(
        authClient: AuthClient,
        userDefaults: UserDefaults = .standard
    ) {
        self.authClient = authClient
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public API
    func handleAuthCallback(_ url: URL) -> Bool {
        authClient.handleGoogleAuthCallback(url)
    }
}

// MARK: - Session Management
extension AuthManager {
    func signInWithGoogle() async throws {
        let user = try await authClient.signInWithGoogle()
        await updateAuthStateOnMain(user: user, provider: .google)
        print("✅ Google Sign-In successful:", user.name ?? "No name")
    }
    
    func signInWithApple() async throws {
        let user = try await authClient.signInWithApple()
        await updateAuthStateOnMain(user: user, provider: .apple)
        print("✅ Apple Sign-In successful:", user.name ?? "No name")
    }
    
    func restoreLastSession() async throws {
        if let provider = getActiveProvider() {
            let user: User?
            
            switch provider {
            case .google:
                user = try await authClient.restoreGoogleSession()
            case .apple:
                user = nil // Apple Sign-In тимчасово не підтримується, бо немає Apple Dev аккаунта.
            }
            
            if let user = user {
                await updateAuthStateOnMain(user: user, provider: provider)
                print("🔐 Session restored for:", user.name ?? "No name")
            } else {
                await updateAuthStateOnMain(user: nil, provider: nil)
                print("🔐 No active session found")
            }
        }
    }
    
    func signOut() {
        if let provider = currentProvider {
            switch provider {
            case .google:
                authClient.signOutGoogle()
            case .apple:
                authClient.signOutApple()
            }
        }
        
        Task {
            await updateAuthStateOnMain(user: nil, provider: nil)
        }
    }
    
    func getAccessToken() async throws -> String? {
        guard let provider = currentProvider else { return nil }
        
        switch provider {
        case .google:
            return try await authClient.getGoogleAccessToken()
        case .apple:
            return nil // Apple не надає access token
        }
    }
}

// MARK: - Private Methods
private extension AuthManager {
    @MainActor
    func updateAuthStateOnMain(user: User?, provider: AuthProvider?) {
        self.currentUser = user
        self.isUserLoggedIn = user != nil
        self.currentProvider = provider
        
        if let provider = provider {
            saveLastProvider(provider)
        } else {
            clearLastProvider()
        }
    }
    
    private func saveLastProvider(_ provider: AuthProvider) {
        userDefaults.set(provider.rawValue, forKey: lastActiveProviderKey)
    }
    
    private func getActiveProvider() -> AuthProvider? {
        guard let rawValue = userDefaults.string(forKey: lastActiveProviderKey) else { return nil }
        return AuthProvider(rawValue: rawValue)
    }
    
    private func clearLastProvider() {
        userDefaults.removeObject(forKey: lastActiveProviderKey)
    }
}
