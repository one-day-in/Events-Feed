import Foundation

struct AppleMusicConstants: MusicServiceConstants {
    static let clientID: String = "apple_music_native"
    static let redirectURIScheme: String = "applemusic"
    static let clientSecret: String? = nil
    static let requiresWebAuth: Bool = false
    
    struct UserDefaultsKeys: MusicServiceUserDefaultsKeys {
        static let accessToken: String = "appleMusicAccessToken"
        static let refreshToken: String = "appleMusicRefreshToken"
        static let tokenExpiry: String = "appleMusicTokenExpiry"
        static let developerToken: String = "appleMusicDeveloperToken"
    }
    
    struct Scopes: MusicServiceScopes {
        static let all: String = ""
    }
    
    struct URLs: MusicServiceURLs {
        static let authBase: String = ""
        static let token: String = ""
    }
}
