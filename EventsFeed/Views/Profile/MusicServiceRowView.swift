import SwiftUI

struct MusicServiceRowView: View {
    let serviceType: MusicServiceType
    let isConnected: Bool
    let onConnect: () -> Void
    let onDisconnect: () -> Void
    
    var body: some View {
        HStack {
            serviceIcon
                
            VStack(alignment: .leading, spacing: 4) {
                Text(serviceType.displayName)
                    .fontWeight(.medium)
                
                Text(isConnected ? "Підключено" : "Не підключено")
                    .font(.caption)
                    .foregroundColor(isConnected ? .green : .red)
            }
            
            Spacer()
            
            // Уніфікована кнопка для всіх сервісів
            Button(action: isConnected ? onDisconnect : onConnect) {
                Text(isConnected ? "Відключити" : "Підключити")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(isConnected ? .red : .green)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private var serviceIcon: some View {
        Group {
            switch serviceType {
            case .spotify:
                Image("spotify")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
            case .youtubeMusic:
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
            case .appleMusic:
                Image(systemName: "applelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MusicServiceRowView(
            serviceType: .spotify,
            isConnected: false,
            onConnect: { print("Connect Spotify") },
            onDisconnect: { print("Disconnect Spotify") }
        )
        
        MusicServiceRowView(
            serviceType: .youtubeMusic,
            isConnected: true,
            onConnect: { print("Connect YouTube Music") },
            onDisconnect: { print("Disconnect YouTube Music") }
        )
        
        MusicServiceRowView(
            serviceType: .appleMusic,
            isConnected: false,
            onConnect: { print("Connect Apple Music") },
            onDisconnect: { print("Disconnect Apple Music") }
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
