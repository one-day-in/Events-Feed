import Foundation

struct User: Codable, Equatable {
    let id: String
    let name: String?
    let email: String?
    let profileImageURL: String?
    let givenName: String?
    let familyName: String?
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.email == rhs.email &&
               lhs.profileImageURL == rhs.profileImageURL &&
               lhs.givenName == rhs.givenName &&
               lhs.familyName == rhs.familyName
    }
}
