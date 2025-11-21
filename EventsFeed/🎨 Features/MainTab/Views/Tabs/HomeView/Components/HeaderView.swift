import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Концерти")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Знайди найкращі події")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    HeaderView()
}
