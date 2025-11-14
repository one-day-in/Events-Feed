import Foundation
import SwiftUI

enum MusicServiceType: CaseIterable, CustomStringConvertible {
    case spotify, youtubeMusic, appleMusic

    var accessTokenKey: String {
        switch self {
        case .spotify: return "spotify_access_token"
        case .youtubeMusic: return "youtube_access_token"
        case .appleMusic: return "applemusic_access_token"
        }
    }

    var tokenExpiryKey: String {
        accessTokenKey + "_expiry"
    }

    var description: String {
        switch self {
        case .spotify: return "Spotify"
        case .youtubeMusic: return "YouTube Music"
        case .appleMusic: return "Apple Music"
        }
    }
    
    // Єдина перевірка, яка потрібна
    var isOAuthService: Bool {
        return self != .appleMusic
    }
}

// MARK: - UI Extensions
extension MusicServiceType {
    var iconName: String {
        switch self {
        case .spotify: return "music.note"
        case .youtubeMusic: return "play.rectangle"
        case .appleMusic: return "apple.logo"
        }
    }
    
    var color: Color {
        switch self {
        case .spotify: return .green
        case .youtubeMusic: return .red
        case .appleMusic: return .pink
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .spotify:
            return LinearGradient(
                colors: [.green, .green.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .youtubeMusic:
            return LinearGradient(
                colors: [.red, .red.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .appleMusic:
            return LinearGradient(
                colors: [.pink, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
