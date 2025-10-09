import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var isSigningOut = false
    
    private let sessionManager: CoordinatedSessionManager
    
    init(sessionManager: CoordinatedSessionManager) {
        self.sessionManager = sessionManager
    }
    
    var currentUser: User? {
        sessionManager.currentUser
    }
    
    var isSpotifyConnected: Bool {
        sessionManager.isSpotifyConnected
    }
    
    var isYouTubeMusicConnected: Bool {
        sessionManager.isYouTubeMusicConnected
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    func handleSignOut() {
        isSigningOut = true
        sessionManager.signOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isSigningOut = false
        }
    }
    
    func connectSpotify() {
        sessionManager.connectSpotify()
    }
    
    func disconnectSpotify() {
        sessionManager.disconnectSpotify()
    }
    
    func connectYouTubeMusic() {
        sessionManager.connectYouTubeMusic()
    }
    
    func disconnectYouTubeMusic() {
        sessionManager.disconnectYouTubeMusic()
    }
}
