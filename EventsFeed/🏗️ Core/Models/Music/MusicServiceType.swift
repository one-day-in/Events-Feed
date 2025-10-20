import Foundation

enum MusicServiceType: String, CaseIterable, Codable {
    case spotify = "Spotify"
    case youtubeMusic = "YouTube Music"
    case appleMusic = "Apple Music"
    
    // MARK: - Властивості для відображення
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .spotify: return "spotify_logo"
        case .youtubeMusic: return "youtube_music_logo"
        case .appleMusic: return "apple_music_logo"
        }
    }
    
    var color: String {
        switch self {
        case .spotify: return "#1DB954" // Зелений Spotify
        case .youtubeMusic: return "#FF0000" // Червоний YouTube
        case .appleMusic: return "#FA243C" // Рожевий Apple Music
        }
    }
    
    // MARK: - Ідентифікатори для авторизації
    var clientID: String {
        switch self {
        case .spotify:
            return "ваш_spotify_client_id"
        case .youtubeMusic:
            return "487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s.apps.googleusercontent.com"
        case .appleMusic:
            return "apple_music_native" // Для Apple Music не потрібен clientID
        }
    }
    
    var redirectScheme: String {
        switch self {
        case .spotify:
            return "ваш_spotify_scheme://callback"
        case .youtubeMusic:
            return "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s"
        case .appleMusic:
            return "apple_music_native" // Apple Music не використовує URL схеми
        }
    }
    
    // MARK: - Legacy сповіщення (якщо потрібно для зворотної сумісності)
    var legacyNotificationName: Notification.Name {
        switch self {
        case .spotify:
            return Notification.Name("spotifyAuthCompleted")
        case .youtubeMusic:
            return Notification.Name("youTubeMusicAuthCompleted")
        case .appleMusic:
            return Notification.Name("appleMusicAuthCompleted")
        }
    }
    
    var legacyErrorNotificationName: Notification.Name {
        switch self {
        case .spotify:
            return Notification.Name("spotifyAuthError")
        case .youtubeMusic:
            return Notification.Name("youTubeMusicAuthError")
        case .appleMusic:
            return Notification.Name("appleMusicAuthError")
        }
    }
    
    var legacyDisconnectNotificationName: Notification.Name {
        switch self {
        case .spotify:
            return Notification.Name("spotifyDisconnected")
        case .youtubeMusic:
            return Notification.Name("youTubeMusicDisconnected")
        case .appleMusic:
            return Notification.Name("appleMusicDisconnected")
        }
    }
}

// MARK: - Розширення для зручності
extension MusicServiceType {
    static func from(rawValue: String) -> MusicServiceType? {
        return MusicServiceType(rawValue: rawValue)
    }
    
    var supportsWebAuth: Bool {
        switch self {
        case .spotify, .youtubeMusic:
            return true
        case .appleMusic:
            return false // Використовує нативну авторизацію
        }
    }
    
    var supportsTokenRefresh: Bool {
        switch self {
        case .spotify, .youtubeMusic:
            return true
        case .appleMusic:
            return false
        }
    }
}
