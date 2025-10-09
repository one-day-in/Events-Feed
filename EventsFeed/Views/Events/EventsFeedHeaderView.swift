import SwiftUI

struct EventsFeedHeaderView: View {
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "music.microphone.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.blue)
                
                Text("My Concert")
                    .font(.custom("DancingScript-Regular", size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: {
                // Дія для сповіщень
            }) {
                Image(systemName: "bell.badge.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EventsFeedHeaderView()
        .frame(height: 60)
        .background(Color(.systemBackground))
}
