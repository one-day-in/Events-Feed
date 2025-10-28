import Foundation
import MediaPlayer

final class AppleMusicServiceClient: BaseMusicServiceClient {
    
    init(tokenStorage: TokenStorage = SecureTokenStorage(service: "AppleMusicService")) {
        super.init(
            serviceType: .appleMusic,
            webAuthHandler: nil,
            tokenStorage: tokenStorage
        )
    }
    
    // MARK: - Authentication
    override func authenticate() async throws {
        let status = await MPMediaLibrary.requestAuthorization()
        
        guard status == .authorized else {
            throw MusicServiceAuthError.accessDenied
        }
        
        await updateState(connected: true)
    }
    
    // MARK: - Session Restoration
    override func restoreSession() async throws {
        let status = MPMediaLibrary.authorizationStatus()
        
        guard status == .authorized else {
            throw MusicServiceAuthError.accessDenied
        }
        
        await updateState(connected: true)
    }
    
    // MARK: - Auth Callback
    override func handleAuthCallback(url: URL) async throws -> Bool {
        return false
    }
    
    // MARK: - Authentication Check
    override func isAuthenticated() -> Bool {
        return MPMediaLibrary.authorizationStatus() == .authorized
    }
}
