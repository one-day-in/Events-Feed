import GoogleSignIn

@MainActor
final class GoogleAuthService: BaseAuthService {
    // MARK: - Initialization
    init() {
        super.init(provider: .google)
        configureGoogleSignIn()
    }
    
    private func configureGoogleSignIn() {
        let config = GIDConfiguration(clientID: GoogleSignInConstants.clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    // MARK: - Sign In
    override func signIn() async throws -> User {
        guard let presentingVC = UIApplication.shared.rootViewController else {
            throw AuthError.noRootViewController
        }
        
        return try await performAuthOperation {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
            return User(from: result.user)
        }
    }
    
    // MARK: - Restore Session
    override func restoreSession() async throws -> User? {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            return nil
        }
        
        return try await performAuthOperation {
            let googleUser = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            return User(from: googleUser)
        }
    }
    
    // MARK: - Sign Out
    override func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try super.signOut()
    }
    
    // MARK: - Get Access Token
    override func getAccessToken() async throws -> String? {
        return GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString
    }
    
    // MARK: - URL Handling
    override func handle(_ url: URL) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
}
