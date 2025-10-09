import SwiftUI
import Kingfisher

struct ConcertCardView: View {
    let concert: Concert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Header
            HStack {
                Text(concert.artist ?? "No atrist")
                    .font(.headline)
                Spacer()
                Text(concert.city)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            .padding(.horizontal) // Додаємо відступи для хедера
            
            // Основний блок зображення
            KFImage(URL(string: concert.imageName))
                .placeholder {
                    ConcertCardPlaceholderView()
                        .frame(height: 300)
                }
                .resizable()
                .frame(height: 300)
                .clipped()
            
            // Footer: Title, genre, price
            VStack(alignment: .leading, spacing: 4) {
                Text(concert.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Жанр: \(String(describing: concert.genre))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let price = concert.price, price > 0 {
                    Text("Ціна: \(Int(price)) грн")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Безкоштовно")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    ConcertCardView(concert: MockData.getConcerts()[1])
}
