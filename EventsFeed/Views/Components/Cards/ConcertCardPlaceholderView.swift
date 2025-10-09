import SwiftUI

struct ConcertCardPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Заглушка для хедера картки
            HStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .shimmer()
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 100, height: 10)
                        .shimmer()
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 60, height: 10)
                        .shimmer()
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // Заглушка для зображення
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 300)
                    
                Image(systemName: "music.microphone.circle")
                    .resizable()
                    .padding()
                    .frame(height: 300)
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.25)
            }
            
            .shimmer()
            
            
            
            // Заглушка для футера
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 150, height: 15)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 80, height: 10)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 120, height: 10)
                    .shimmer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .opacity(0.6)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    ConcertCardPlaceholderView()
}
