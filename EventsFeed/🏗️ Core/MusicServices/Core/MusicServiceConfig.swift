import SwiftUI

enum ServiceConfig {
    case oauth(OAuthConfig)
    case native
}

struct OAuthConfig {
    let authURL: String
    let tokenURL: String
    let clientID: String
    let redirectURI: String
    let scopes: String
    let accessType: String?
    let prompt: String?
    let storageKey: String
}

struct ServiceDisplay {
    let displayName: String
    let iconName: String
    let color: Color
    let gradient: LinearGradient
}
