import SwiftUI

struct ConcertCardPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Заглушка для хедера картки
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .shimmer()
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 12)
                        .shimmer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 10)
                        .shimmer()
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // Заглушка для зображення
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(
                    Image(systemName: "music.microphone.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(.gray.opacity(0.5))
                )
                .shimmer()

            // Заглушка для футера
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 12)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 12)
                    .shimmer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}

#Preview("Default") {
    ConcertCardPlaceholderView()
}

#Preview("In List") {
    ScrollView {
        ForEach(0..<13, id: \.self) { _ in
            ConcertCardPlaceholderView()
        }
    }
}
