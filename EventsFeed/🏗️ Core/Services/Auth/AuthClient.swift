import UIKit
import AuthenticationServices
import GoogleSignIn

final class AuthClient: NSObject {
    
    // MARK: - Configuration
    override init() {
        super.init()
        configureGoogleSignIn()
    }
    
    private func configureGoogleSignIn() {
        let config = GIDConfiguration(clientID: GoogleSignInConstants.clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    // MARK: - Google Auth
    @MainActor
    func signInWithGoogle() async throws -> User {
        guard let presentingVC = UIApplication.shared.rootViewController else {
            throw URLError(.badURL)
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
        return User(from: result.user)
    }
    
    func restoreGoogleSession() async throws -> User? {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            return nil
        }
        
        let googleUser = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        return User(from: googleUser)
    }
    
    func signOutGoogle() throws {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func getGoogleAccessToken() async throws -> String? {
        return GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString
    }
    
    func handleGoogleAuthCallback(_ url: URL) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: - Apple Auth
    private var appleContinuation: CheckedContinuation<User, Error>?
    
    func signInWithApple() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            self.appleContinuation = continuation
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    func signOutApple() throws {
        // Apple Sign-In не вимагає явного signOut
    }
}

// MARK: - Apple Sign-In Delegates
extension AuthClient: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let continuation = appleContinuation else { return }
        
        let user = User(from: appleIDCredential)
        continuation.resume(returning: user)
        self.appleContinuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithError error: Error) {
        appleContinuation?.resume(throwing: error)
        self.appleContinuation = nil
    }
}

extension AuthClient: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.rootViewController?.view.window ?? UIWindow()
    }
}
