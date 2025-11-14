import Foundation
import SwiftUI

struct MockData {
    
    static func getUser() -> User {
        return User(
            id: "123456789",
            name: "John Doe",
            email: "john.doe@example.com",
            avatarURL: "https://picsum.photos/200",
            givenName: "John",
            familyName: "Doe",
            isEmailVerified: true
        )
    }
}
