import SwiftUI

struct MusicServiceCell: View {
    let service: MusicServiceType
    let isConnected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            serviceIcon
            serviceInfo
            Spacer()
            connectionControl
        }
        .padding(.vertical, 4)
    }
    
    private var serviceIcon: some View {
        Image(systemName: service.display.iconName)
            .font(.system(size: 24))
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(service.display.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var serviceInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(service.display.displayName)
                .font(.body)
                .foregroundColor(.primary)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var connectionControl: some View {
        Toggle("", isOn: Binding(
            get: { isConnected },
            set: { onToggle($0) }
        ))
        .labelsHidden()
        .scaleEffect(0.8)
    }
    
    private var statusText: String {
        return isConnected ? "Connected" : "Not connected"
    }
}
