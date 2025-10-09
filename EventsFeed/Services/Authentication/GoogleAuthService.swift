import GoogleSignIn
import GoogleSignInSwift

final class GoogleAuthService: AuthServiceProtocol {
    
    private let signInInstance = GIDSignIn.sharedInstance
       
    var isUserLoggedIn: Bool {
        return signInInstance.currentUser != nil
    }
    
    var currentUser: User? {
        guard let gidUser = signInInstance.currentUser else {
            return nil
        }
        return User(
            id: gidUser.userID ?? "",
            name: gidUser.profile?.name,
            email: gidUser.profile?.email,
            profileImageURL: gidUser.profile?.imageURL(withDimension: 120)?.absoluteString,
            givenName: gidUser.profile?.givenName,
            familyName: gidUser.profile?.familyName
        )
    }
    
    init() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "487751122186-an2bm47rbc80taujsrjgfqv3ta4rlumn.apps.googleusercontent.com"
        )
    }
    
    func signIn() async throws -> User {
        guard let rootViewController = await MainActor.run(body: {
            UIApplication.shared.rootViewController
        }) else {
            throw AuthError.noRootViewController
        }
        
        do {
            let gidSignInResult = try await signInInstance.signIn(withPresenting: rootViewController)
            let gidUser = gidSignInResult.user
            
            return User(
                id: gidUser.userID ?? "",
                name: gidUser.profile?.name,
                email: gidUser.profile?.email,
                profileImageURL: gidUser.profile?.imageURL(withDimension: 120)?.absoluteString,
                givenName: gidUser.profile?.givenName,
                familyName: gidUser.profile?.familyName
            )
        } catch {
            // Конвертуємо помилки Google Sign-In в наші типи
            if (error as NSError).domain == "com.google.GIDSignIn" {
                throw AuthError.signInFailed(error)
            }
            throw error
        }
    }
    
    func signOut() throws {
        signInInstance.signOut()
    }
    
    func restoreSession() async {
        _ = try? await signInInstance.restorePreviousSignIn()
    }
    
    func handle(_ url: URL) -> Bool {
        return signInInstance.handle(url)
    }
}

extension UIApplication {
    @MainActor
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
