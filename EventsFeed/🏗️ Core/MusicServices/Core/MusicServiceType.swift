import SwiftUI

enum MusicServiceType: CaseIterable {
    case spotify
    case youtubeMusic
    case appleMusic
    
    // MARK: - Public Interface
    var config: ServiceConfig {
        switch self {
        case .spotify:
            return .oauth(MusicServiceType.spotifyOAuth)
        case .youtubeMusic:
            return .oauth(MusicServiceType.youtubeOAuth)
        case .appleMusic:
            return .native
        }
    }
    
    var display: ServiceDisplay {
        switch self {
        case .spotify:
            return MusicServiceType.spotifyDisplay
        case .youtubeMusic:
            return MusicServiceType.youtubeDisplay
        case .appleMusic:
            return MusicServiceType.appleDisplay
        }
    }
    
    // MARK: - Конфігурації
    private static let spotifyOAuth = OAuthConfig(
        authURL: "https://accounts.spotify.com/authorize",
        tokenURL: "https://accounts.spotify.com/api/token",
        clientID: "YOUR_SPOTIFY_CLIENT_ID",
        redirectURI: "yourapp://spotify-auth",
        scopes: "user-read-email user-read-private",
        accessType: nil,
        prompt: nil,
        storageKey: "spotify_music_token"
    )
    
    private static let youtubeOAuth = OAuthConfig(
        authURL: "https://accounts.google.com/o/oauth2/v2/auth",
        tokenURL: "https://oauth2.googleapis.com/token",
        clientID: "YOUTUBE_CLIENT_ID",
        redirectURI: "yourapp:/oauth2redirect",
        scopes: "https://www.googleapis.com/auth/youtube.readonly",
        accessType: "offline",
        prompt: "consent",
        storageKey: "youtube_music_token"
    )
    
    private static let spotifyDisplay = ServiceDisplay(
        displayName: "Spotify",
        iconName: "music.note",
        color: .green,
        gradient: LinearGradient(
            colors: [.green, .green.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    
    private static let youtubeDisplay = ServiceDisplay(
        displayName: "YouTube Music",
        iconName: "play.rectangle",
        color: .red,
        gradient: LinearGradient(
            colors: [.red, .red.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    
    private static let appleDisplay = ServiceDisplay(
        displayName: "Apple Music",
        iconName: "apple.logo",
        color: .pink,
        gradient: LinearGradient(
            colors: [.pink, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )

}
