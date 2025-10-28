import Foundation
import GoogleSignIn

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
