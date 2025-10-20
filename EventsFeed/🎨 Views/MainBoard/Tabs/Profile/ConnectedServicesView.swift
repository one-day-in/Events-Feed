//// Features/Profile/Views/Components/ConnectedServicesView.swift
//import SwiftUI
//
//struct ConnectedServicesView: View {
//    @ObservedObject var viewModel: ProfileViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Підключені сервіси")
//                .font(.headline)
//                .foregroundColor(.primary)
//            
//            // Spotify
//            MusicServiceRowView(
//                serviceType: .spotify,
//                isConnected: viewModel.isServiceConnected(.spotify),
//                onConnect: { viewModel.connectSpotify() },
//                onDisconnect: { viewModel.disconnectSpotify() }
//            )
//            
//            // YouTube Music
//            MusicServiceRowView(
//                serviceType: .youtubeMusic,
//                isConnected: viewModel.isServiceConnected(.youtubeMusic),
//                onConnect: { viewModel.connectYouTubeMusic() },
//                onDisconnect: { viewModel.disconnectYouTubeMusic() }
//            )
//            
//            // Apple Music
//            MusicServiceRowView(
//                serviceType: .appleMusic,
//                isConnected: viewModel.isServiceConnected(.appleMusic),
//                onConnect: { viewModel.connectAppleMusic() },
//                onDisconnect: { viewModel.disconnectAppleMusic() }
//            )
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
//    }
//}
//
//#Preview {
//    let sessionManager = DIContainer.shared.resolve(SessionManager.self)
//    let viewModel = ProfileViewModel(sessionManager: sessionManager)
//    
//    return ConnectedServicesView(viewModel: viewModel)
//        .padding()
//        .background(Color(.systemGroupedBackground))
//}
