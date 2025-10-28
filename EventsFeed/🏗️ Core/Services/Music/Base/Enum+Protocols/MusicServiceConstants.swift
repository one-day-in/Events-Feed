protocol MusicServiceConstants {
    var clientID: String { get }
    var redirectURIScheme: String { get }
    var clientSecret: String? { get }
    var scopes: String { get }
    var authBaseURL: String { get }
    var tokenURL: String { get }
}

struct SpotifyConstants: MusicServiceConstants {
    let clientID = "ваш_spotify_client_id"
    let redirectURIScheme = "ваш_spotify_scheme"
    let clientSecret: String? = "ваш_spotify_secret"
    let scopes = "user-read-private user-read-email"
    let authBaseURL = "https://accounts.spotify.com/authorize"
    let tokenURL = "https://accounts.spotify.com/api/token"
}

struct YouTubeMusicConstants: MusicServiceConstants {
    let clientID = "487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s.apps.googleusercontent.com"
    let redirectURIScheme = "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s"
    let clientSecret: String? = "ваш_youtube_secret"
    let scopes = "https://www.googleapis.com/auth/youtube"
    let authBaseURL = "https://accounts.google.com/o/oauth2/auth"
    let tokenURL = "https://oauth2.googleapis.com/token"
}
