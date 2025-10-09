enum YouTubeMusicConstants: MusicServiceConstants {
    static let clientID = "487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s.apps.googleusercontent.com"
    static let clientSecret: String? = nil
    static let redirectURIScheme = "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s"
    
    enum UserDefaultsKeys: MusicServiceUserDefaultsKeys {
        static let accessToken = "youtubeMusicAccessToken"
        static let refreshToken = "youtubeMusicRefreshToken"
        static let tokenExpiry = "youtubeMusicTokenExpiry"
    }
    
    enum Scopes: MusicServiceScopes {
        static let userLibraryRead = "https://www.googleapis.com/auth/youtube.readonly"
        
        static var all: String {
            return userLibraryRead
        }
    }
    
    enum URLs: MusicServiceURLs {
        static let authBase = "https://accounts.google.com/o/oauth2/auth"
        static let token = "https://oauth2.googleapis.com/token"
        static let apiBase = "https://youtube.googleapis.com/youtube/v3"
    }
}
