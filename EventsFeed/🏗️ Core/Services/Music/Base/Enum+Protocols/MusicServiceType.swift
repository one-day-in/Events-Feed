import Foundation

enum MusicServiceType: String, CaseIterable, Codable {
    case spotify = "Spotify"
    case youtubeMusic = "YouTube Music"
    case appleMusic = "Apple Music"
    
    var displayName: String {
        return rawValue
    }
}

// MARK: - Key Management
extension MusicServiceType {
    var accessTokenKey: String { "\(rawValue)_access_token" }
    var refreshTokenKey: String { "\(rawValue)_refresh_token" }
    var tokenExpiryKey: String { "\(rawValue)_token_expiry" }
    var isNativeAuth: Bool { self == .appleMusic }
}
