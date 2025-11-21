import SwiftUI

struct MusicServicesView: View {
    let connectedServices: [MusicServiceType]
    let onConnect: (MusicServiceType) -> Void
    let onDisconnect: (MusicServiceType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Музичні сервіси")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(connectedServices.count)/\(MusicServiceType.allCases.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(.systemGray5)))
            }
            
            // Spotify
            serviceRow(.spotify)
            
            // YouTube Music
            serviceRow(.youtubeMusic)
            
            // Apple Music
            serviceRow(.appleMusic)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Service Row
    private func serviceRow(_ serviceType: MusicServiceType) -> some View {
        let isConnected = connectedServices.contains(serviceType)
        
        return HStack {
            serviceIcon(serviceType)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(serviceType.displayName)
                    .fontWeight(.medium)
                
                Text(isConnected ? "Підключено" : "Не підключено")
                    .font(.caption)
                    .foregroundColor(isConnected ? .green : .red)
            }
            
            Spacer()
            
            Button(action: {
                if isConnected {
                    onDisconnect(serviceType)
                } else {
                    onConnect(serviceType)
                }
            }) {
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
    
    private func serviceIcon(_ serviceType: MusicServiceType) -> some View {
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

// MARK: - Preview
#Preview {
    // Тепер можна тестувати без залежності від ViewModel
    MusicServicesView(
        connectedServices: [.spotify, .youtubeMusic], // Підключені сервіси
        onConnect: { service in
            print("Connect: \(service.displayName)")
        },
        onDisconnect: { service in
            print("Disconnect: \(service.displayName)")
        }
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Всі відключені") {
    MusicServicesView(
        connectedServices: [], // Жодного підключеного сервісу
        onConnect: { _ in print("Connect") },
        onDisconnect: { _ in print("Disconnect") }
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Всі підключені") {
    MusicServicesView(
        connectedServices: MusicServiceType.allCases, // Всі сервіси підключені
        onConnect: { _ in print("Connect") },
        onDisconnect: { _ in print("Disconnect") }
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
