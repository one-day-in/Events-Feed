import Foundation

extension Notification.Name {
    // App Lifecycle
    static let appInitializationCompleted = Notification.Name("appInitializationCompleted")
    static let appDidBecomeActive = Notification.Name("appDidBecomeActive")
    static let appWillResignActive = Notification.Name("appWillResignActive")
    
    // App State Management
    static let appStateShouldChange = Notification.Name("appStateShouldChange")
    static let appPhaseShouldChange = Notification.Name("appPhaseShouldChange")
    
    // Уніфіковані сповіщення для всіх музичних сервісів
    static let musicServiceAuthSuccess = Notification.Name("musicServiceAuthSuccess")
    static let musicServiceAuthError = Notification.Name("musicServiceAuthError")
    static let musicServiceDisconnected = Notification.Name("musicServiceDisconnected")
    static let musicServiceConnectionStateChanged = Notification.Name("musicServiceConnectionStateChanged")
    
    
    static let authStateChanged = Notification.Name("authStateChanged")
}

// Ключі для userInfo
struct NotificationKeys {
    static let serviceType = "serviceType"
    static let errorMessage = "errorMessage"
    static let accessToken = "accessToken"
    static let isConnected = "isConnected"
    static let isAuthenticated = "isAuthenticated"
    
    // App State Keys
    static let appState = "appState"
    static let appPhase = "appPhase"
}
