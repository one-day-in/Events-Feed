import SwiftUI

struct ConnectedServicesView: View {
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Підключені сервіси")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Spotify
            MusicServiceRowView(
                serviceType: .spotify,
                isConnected: sessionManager.isSpotifyConnected,
                onConnect: { sessionManager.connectSpotify() },
                onDisconnect: { sessionManager.disconnectSpotify() }
            )
            
            // YouTube Music
            MusicServiceRowView(
                serviceType: .youtubeMusic,
                isConnected: sessionManager.isYouTubeMusicConnected,
                onConnect: { sessionManager.connectYouTubeMusic() },
                onDisconnect: { sessionManager.disconnectYouTubeMusic() }
            )
            
            // Apple Music
            MusicServiceRowView(
                serviceType: .appleMusic,
                isConnected: sessionManager.isAppleMusicConnected,
                onConnect: { sessionManager.connectAppleMusic() },
                onDisconnect: { sessionManager.disconnectAppleMusic() }
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

//#Preview {
//    let userSessionManager = UserSessionManager(authService: <#T##any AuthServiceProtocol#>)
//    ConnectedServicesView(sessionManager: CoordinatedSessionManager(
//        userSessionManager: MockUserSessionManager(),
//        musicServiceManager: MockMusicServiceManager()
//    ))
//}
