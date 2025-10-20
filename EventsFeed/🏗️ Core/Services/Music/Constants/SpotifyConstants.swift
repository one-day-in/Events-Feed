struct SpotifyConstants: MusicServiceConstants {
    static let clientID = "4bbaf9a8aea74fcda954bec6b6860f6d"
    static let redirectURIScheme = "spotify-auth"
    static let clientSecret: String? = nil
    static let requiresWebAuth: Bool = true
    
    struct UserDefaultsKeys: MusicServiceUserDefaultsKeys {
        static let accessToken = "spotifyAccessToken"
        static let refreshToken = "spotifyRefreshToken"
        static let tokenExpiry = "spotifyTokenExpiry"
    }
    
    struct Scopes: MusicServiceScopes {
        static let userReadPrivate = "user-read-private"
        static let userReadEmail = "user-read-email"
        static let userTopRead = "user-top-read"
        
        static var all: String {
            return [userReadPrivate, userReadEmail, userTopRead].joined(separator: " ")
        }
    }
    
    struct URLs: MusicServiceURLs {
        static let authBase = "https://accounts.spotify.com/authorize"
        static let token = "https://accounts.spotify.com/api/token"
    }
}
