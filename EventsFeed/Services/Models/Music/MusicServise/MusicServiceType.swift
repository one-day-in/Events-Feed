import SwiftUI

enum MusicServiceType: String, CaseIterable {
    case spotify
    case youtubeMusic
    case appleMusic
    
    // MARK: - UI Properties
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
    
    var color: Color {
        switch self {
        case .spotify: return .green
        case .youtubeMusic: return .red
        case .appleMusic: return .pink
        }
    }
    
    var requiresWebAuth: Bool {
        switch self {
        case .spotify, .youtubeMusic:
            return true
        case .appleMusic:
            return false
        }
    }
    
    // MARK: - Notification Names
    var successNotificationName: Notification.Name {
        switch self {
        case .spotify: return .spotifyAuthSuccess
        case .youtubeMusic: return .youtubeMusicAuthSuccess
        case .appleMusic: return .appleMusicAuthSuccess
        }
    }
    
    var errorNotificationName: Notification.Name {
        switch self {
        case .spotify: return .spotifyAuthError
        case .youtubeMusic: return .youtubeMusicAuthError
        case .appleMusic: return .appleMusicAuthError
        }
    }
        
    // MARK: - Legacy Notification Names
    var legacyNotificationName: Notification.Name {
        switch self {
        case .spotify: return .spotifyAuthSuccess
        case .youtubeMusic: return .youtubeMusicAuthSuccess
        case .appleMusic: return .musicServiceAuthSuccess
        }
    }
    
    var legacyErrorNotificationName: Notification.Name {
        switch self {
        case .spotify: return .spotifyAuthError
        case .youtubeMusic: return .youtubeMusicAuthError
        case .appleMusic: return .musicServiceAuthError
        }
    }
    
    var legacyDisconnectNotificationName: Notification.Name {
        switch self {
        case .spotify: return .spotifyDisconnected
        case .youtubeMusic: return .youtubeMusicDisconnected
        case .appleMusic: return .musicServiceDisconnected
        }
    }
    
    
}
