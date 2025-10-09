import Foundation

enum MusicServiceType: String, CaseIterable {
    case spotify
    case youtubeMusic
    case appleMusic
    
    var displayName: String {
        switch self {
        case .spotify: return "Spotify"
        case .youtubeMusic: return "YouTube Music"
        case .appleMusic: return "Apple Music"
        }
    }
    
    var iconName: String {
        switch self {
        case .spotify: return "spotify"
        case .youtubeMusic: return "play.circle.fill"
        case .appleMusic: return "applelogo"
        }
    }
    
    // Для зворотної сумісності з існуючими сповіщеннями
    var legacyNotificationName: Notification.Name {
        switch self {
        case .spotify:
            return .spotifyAuthSuccess
        case .youtubeMusic:
            return .youtubeMusicAuthSuccess
        case .appleMusic:
            return .musicServiceAuthSuccess
        }
    }
    
    var legacyErrorNotificationName: Notification.Name {
        switch self {
        case .spotify:
            return .spotifyAuthError
        case .youtubeMusic:
            return .youtubeMusicAuthError
        case .appleMusic:
            return .musicServiceAuthError
        }
    }
    
    var legacyDisconnectNotificationName: Notification.Name {
        switch self {
        case .spotify:
            return .spotifyDisconnected
        case .youtubeMusic:
            return .youtubeMusicDisconnected
        case .appleMusic:
            return .musicServiceDisconnected
        }
    }
}
