import SwiftUI

struct ConnectedServicesView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Підключені сервіси")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Spotify
            MusicServiceRowView(
                serviceType: .spotify,
                isConnected: viewModel.isSpotifyConnected,
                onConnect: { viewModel.connectSpotify() },
                onDisconnect: { viewModel.disconnectSpotify() }
            )
            
            // YouTube Music
            MusicServiceRowView(
                serviceType: .youtubeMusic,
                isConnected: viewModel.isYouTubeMusicConnected,
                onConnect: { viewModel.connectYouTubeMusic() },
                onDisconnect: { viewModel.disconnectYouTubeMusic() }
            )
            
            if !allServicesConnected {
                Text("🎵 Підключіть музичні сервіси для кращого досвіду")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
        }
    }
    
    private var allServicesConnected: Bool {
        return viewModel.isSpotifyConnected &&
               viewModel.isYouTubeMusicConnected
    }
}

#Preview {
    let profileViewModel = DIContainer.shared.resolve(ProfileViewModel.self)
    
    return ConnectedServicesView(viewModel: profileViewModel)
}
