import SwiftUI

struct AppInfoView: View {
    let appVersion: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Про додаток")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                InfoRow(icon: "app.badge", title: "Версія", value: appVersion)
            }
            .opacity(0.8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    AppInfoView(appVersion: "1.0.1")
}
