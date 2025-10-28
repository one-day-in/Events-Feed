import SwiftUI

struct ErrorBannerView: View {
    let error: AppError
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: error.icon)
                .font(.title2)
                .foregroundColor(error.color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(12)
        .frame(minHeight: 50)
        .background(error.color)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
    }
}

extension AppError {
    var icon: String {
        switch self {
        case .network:
            return "wifi.exclamationmark"
        case .auth:
            return "person.crop.circle.badge.exclamationmark"
        case .music:
            return "speaker.slash"
        case .unknown:
            return "exclamationmark.triangle"
        }
    }
    
    var color: Color {
        switch self {
        case .network:
            return .orange
        case .auth:
            return .red
        case .music:
            return .purple
        case .unknown:
            return .gray
        }
    }
}
