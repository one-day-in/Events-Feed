import SwiftUI
import Kingfisher

struct ConcertCardView: View {
    let concert: Concert
    @State private var isPressed = false
    @State private var imageLoaded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(concert.artist ?? "Невідомий виконавець")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text(concert.city)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Дата концерту
                VStack(alignment: .trailing, spacing: 4) {
                     Text(concert.date, style: .date)
                         .font(.caption)
                         .fontWeight(.medium)
                         .foregroundColor(.primary)
                     Text(concert.date, style: .time)
                         .font(.caption2)
                         .foregroundColor(.secondary)
                 }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Основний блок зображення з анімацією
            ZStack {
                if let imageUrl = URL(string: concert.imageName) {
                    KFImage(imageUrl)
                        .onSuccess { _ in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                imageLoaded = true
                            }
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .opacity(imageLoaded ? 1 : 0)
                        .scaleEffect(imageLoaded ? 1 : 0.95)
                } else {
                    // Fallback image з анімацією
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                        )
                }
                
                // Градієнт overlay для кращого читання тексту
                LinearGradient(
                    colors: [.clear, .black.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Footer з покращеною інформацією
            VStack(alignment: .leading, spacing: 8) {
                Text(concert.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    if let genre = concert.genre {
                        HStack {
                            Image(systemName: "guitars")
                                .font(.caption2)
                            Text(genre)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let price = concert.price, price > 0 {
                        HStack {
                            Image(systemName: "tag")
                                .font(.caption2)
                            Text("\(Int(price)) грн")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.blue)
                    } else {
                        HStack {
                            Image(systemName: "gift")
                                .font(.caption2)
                            Text("Безкоштовно")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.green)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(
            color: .black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .onTapGesture {
            // Анімація натискання
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    ConcertCardView(concert: MockData.getConcerts()[2])
}
