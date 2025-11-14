import SwiftUI

struct AccountStatusSectionView: View {
    var body: some View {
        Section {
            NavigationLink(destination: EmptyView()) {
                SettingsRow(icon: "key", title: "Privacy & Security")
            }
        }
    }
}

struct MusicServicesSectionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Section(header: Text("Connected Services").textCase(.none)) {
            ForEach(MusicServiceType.allCases, id: \.self) { service in
                MusicServiceCell(
                    service: service,
                    isConnected: viewModel.connectedServices.contains(service),
                    onToggle: { isConnecting in
                        if isConnecting {
                            Task { await viewModel.connectMusicService(service) }
                        } else {
                            viewModel.disconnectMusicService(service)
                        }
                    }
                )
            }
        }
    }
}

struct AppSettingsSectionView: View {
    var body: some View {
        Section(header: Text("Application").textCase(.none)) {
            NavigationLink(destination: EmptyView()) {
                SettingsRow(icon: "bell", title: "Notifications")
            }
            
            NavigationLink(destination: EmptyView()) {
                SettingsRow(icon: "paintbrush", title: "Appearance")
            }
        }
    }
}

struct InfoSectionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Section {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                Text("ConcertBox")
                
                Spacer()
                
                Text("v\(viewModel.appVersion)")
                    .foregroundColor(.secondary)
            }
            
            NavigationLink(destination: EmptyView()) {
                SettingsRow(icon: "questionmark.circle", title: "Help")
            }
        }
    }
}

struct LogoutSectionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Button(action: {
                viewModel.logout()
            }) {
                HStack {
                    Spacer()
                    Text("Log Out")
                        .foregroundColor(.red)
                        .fontWeight(.medium)
                    Spacer()
                }
            }
        }
    }
}

// Допоміжний компонент для рядків налаштувань
struct SettingsRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(title)
            
            Spacer()
            
        }
    }
}
