import Foundation
import AuthenticationServices
import CryptoKit

final class AppleAuthService: BaseAuthService {
    // MARK: - Apple Sign-In Properties
    private var currentNonce: String?
    private var continuation: CheckedContinuation<User, Error>?
    private let errorService: ErrorService
    
    // MARK: - Initialization
    init(errorService: ErrorService = .shared) {
        self.errorService = errorService
        super.init()
    }
    
    override func signIn(with options: AuthSignInOptions?) async throws -> User {
        setLoading(true)
        defer { setLoading(false) }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            performAppleSignIn()
        }
    }
    
    override func signOut() throws {
        do {
            KeychainHelper.shared.deleteAppleUserData()
            try super.signOut()
        } catch {
            errorService.reportAuthError("Failed to sign out from Apple", context: "Apple Sign-Out")
            throw error
        }
    }
    
    override func restoreSession() async {
        setLoading(true)
        
        if let storedUserData = KeychainHelper.shared.getAppleUserData(),
           let user = try? JSONDecoder().decode(User.self, from: storedUserData) {
            updateUser(user, isLoggedIn: true)
        }
        
        setLoading(false)
    }
    
    // MARK: - Apple Sign-In Implementation
    private func performAppleSignIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

    // MARK: - Helper Methods
extension AppleAuthService {
    
    private func createUser(from credential: ASAuthorizationAppleIDCredential) -> User {
        let userId = credential.user
        
        let email = credential.email
        let fullName = credential.fullName
        let name = [fullName?.givenName, fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
        
        let user = User(
            id: userId,
            name: name.isEmpty ? "Apple User" : name,
            email: email,
            avatarURL: nil,
            givenName: fullName?.givenName,
            familyName: fullName?.familyName,
            isEmailVerified: true
        )
        
        if let userData = try? JSONEncoder().encode(user) {
            KeychainHelper.shared.saveAppleUserData(userData)
        }
        
        return user
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

    // MARK: - ASAuthorizationControllerDelegate
extension AppleAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            let error = AuthError.appleSignInFailed
            errorService.reportAuthError("Invalid credential type", context: "Apple Sign-In")
            continuation?.resume(throwing: error)
            continuation = nil
            return
        }
        
        guard currentNonce != nil else {
            let error = AuthError.invalidState
            errorService.reportAuthError("Missing nonce", context: "Apple Sign-In")
            continuation?.resume(throwing: error)
            continuation = nil
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let _ = String(data: appleIDToken, encoding: .utf8) else {
            let error = AuthError.tokenNotFound
            errorService.reportAuthError("Missing identity token", context: "Apple Sign-In")
            continuation?.resume(throwing: error)
            continuation = nil
            return
        }
        
        let user = createUser(from: appleIDCredential)
        updateUser(user, isLoggedIn: true)
        
        continuation?.resume(returning: user)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let authError = error.toAuthError()
        errorService.report(authError, context: "Apple Sign-In")
        
        setLoading(false)
        continuation?.resume(throwing: authError)
        continuation = nil
    }
}

    // MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if Thread.isMainThread {
            return getKeyWindow()
        } else {
            return DispatchQueue.main.sync {
                getKeyWindow()
            }
        }
    }
    
    private func getKeyWindow() -> UIWindow {
        if Thread.isMainThread {
            return getKeyWindowImpl()
        } else {
            return DispatchQueue.main.sync {
                getKeyWindowImpl()
            }
        }
    }
    
    private func getKeyWindowImpl() -> UIWindow {
        guard let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene,
        let window = scene.windows.first(where: \.isKeyWindow) else {
            return UIWindow()
        }
        return window
    }
}
