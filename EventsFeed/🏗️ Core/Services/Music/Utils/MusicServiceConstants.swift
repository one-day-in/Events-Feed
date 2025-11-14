import Foundation

struct MusicServiceConstants {
    let serviceType: MusicServiceType
    let authBaseURL: String
    let tokenURL: String
    let clientID: String
    let redirectURI: String
    let scopes: String

    static let spotify = MusicServiceConstants(
        serviceType: .spotify,
        authBaseURL: "https://accounts.spotify.com/authorize",
        tokenURL: "https://accounts.spotify.com/api/token",
        clientID: "4bbaf9a8aea74fcda954bec6b6860f6d",
        redirectURI: "oneday.com.EventsFeed://spotify-auth",
        scopes: "user-read-email user-read-private"
    )

    static let youtubeMusic = MusicServiceConstants(
        serviceType: .youtubeMusic,
        authBaseURL: "https://accounts.google.com/o/oauth2/v2/auth",
        tokenURL: "https://oauth2.googleapis.com/token",
        clientID: "487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s.apps.googleusercontent.com",
        redirectURI: "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s:/oauth2redirect",
        scopes: "https://www.googleapis.com/auth/youtube.readonly"
    )
}
