import GoogleSignIn

final class GoogleAuthService: BaseAuthService {
    private let signInInstance = GIDSignIn.sharedInstance
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "487751122186-an2bm47rbc80taujsrjgfqv3ta4rlumn.apps.googleusercontent.com"
        )
        self.updateUserState()
    }
    
    override func signIn(with options: AuthSignInOptions?) async throws -> User {
        setLoading(true)
        defer { setLoading(false) }
        
        let rootViewController = options?.presentationContext as? UIViewController ?? UIApplication.shared.rootViewController
        
        guard let viewController = rootViewController else {
            throw AuthError.noRootViewController
        }
        
        do {
            let gidSignInResult = try await signInInstance.signIn(withPresenting: viewController)
            let gidUser = gidSignInResult.user
            let user = User(from: gidUser)
            
            updateUser(user, isLoggedIn: true)
            return user
        } catch {
            if (error as NSError).domain == "com.google.GIDSignIn" {
                throw AuthError.signInFailed(error)
            }
            throw error
        }
    }
    
    override func signOut() throws {
        signInInstance.signOut()
        updateUserState()
        try super.signOut()
    }
    
    override func restoreSession() async {
        setLoading(true)
        defer { setLoading(false) }
        
        do {
            _ = try await signInInstance.restorePreviousSignIn()
            updateUserState()
        } catch {
            print("Failed to restore session: \(error)")
        }
    }
    
    override func handle(_ url: URL) -> Bool {
        return signInInstance.handle(url)
    }
    
    private func updateUserState() {
        let gidUser = signInInstance.currentUser
        let newUser = gidUser.map { User(from: $0) }
        updateUser(newUser, isLoggedIn: gidUser != nil)
    }
}
