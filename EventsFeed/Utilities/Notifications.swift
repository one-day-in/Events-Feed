import Foundation

extension Notification.Name {
    static let appInitializationCompleted = Notification.Name("appInitializationCompleted")
    
    static let musicServiceAuthSuccess = Notification.Name("MusicServiceAuthSuccess")
    static let musicServiceAuthError = Notification.Name("MusicServiceAuthError")
    static let musicServiceDisconnected = Notification.Name("MusicServiceDisconnected")
    static let musicServiceTokenRefreshed = Notification.Name("MusicServiceTokenRefreshed")
}

extension Notification.Name {
    static let appleMusicAuthSuccess = Notification.Name("appleMusicAuthSuccess")
    static let appleMusicAuthError = Notification.Name("appleMusicAuthError")
    static let appleMusicDisconnected = Notification.Name("appleMusicDisconnected")
}

extension Notification.Name {
    static let spotifyAuthSuccess = Notification.Name("SpotifyAuthSuccess")
    static let spotifyAuthError = Notification.Name("SpotifyAuthError")
    static let spotifyDisconnected = Notification.Name("SpotifyDisconnected")
}

extension Notification.Name {
    static let youtubeMusicAuthSuccess = Notification.Name("YouTubeMusicAuthSuccess")
    static let youtubeMusicAuthError = Notification.Name("YouTubeMusicAuthError")
    static let youtubeMusicDisconnected = Notification.Name("YouTubeMusicDisconnected")
    static let youtubeMusicAuthCallback = Notification.Name("youtubeMusicAuthCallback")
}
