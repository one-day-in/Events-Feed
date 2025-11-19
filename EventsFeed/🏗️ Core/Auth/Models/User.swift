import Foundation
import GoogleSignIn
import AuthenticationServices

struct User: Codable, Equatable {
    let id: String
    let name: String?
    let email: String?
    let avatarURL: String?
    let givenName: String?
    let familyName: String?
    
    let isEmailVerified: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatarURL = "profileImageURL"
        case givenName
        case familyName
        case isEmailVerified
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

#if canImport(GoogleSignIn)
extension User {
    init(from gidUser: GIDGoogleUser) {
        let profile = gidUser.profile
        
        self.init(
            id: gidUser.userID ?? UUID().uuidString,
            name: profile?.name,
            email: profile?.email,
            avatarURL: profile?.imageURL(withDimension: 120)?.absoluteString,
            givenName: profile?.givenName,
            familyName: profile?.familyName,
            isEmailVerified: nil // Google не надає цю інформацію без додаткових запитів
        )
    }
}
#endif

#if canImport(AuthenticationServices)
extension User {
    init(from appleIDCredential: ASAuthorizationAppleIDCredential) {
        let fullName = appleIDCredential.fullName
        let name: String?
        
        if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
            name = "\(givenName) \(familyName)"
        } else {
            name = fullName?.givenName ?? fullName?.familyName
        }
        
        self.init(
            id: appleIDCredential.user,
            name: name,
            email: appleIDCredential.email,
            avatarURL: nil, // Apple не надає аватар
            givenName: fullName?.givenName,
            familyName: fullName?.familyName,
            isEmailVerified: true // Apple email завжди верифікований
        )
    }
}
#endif
