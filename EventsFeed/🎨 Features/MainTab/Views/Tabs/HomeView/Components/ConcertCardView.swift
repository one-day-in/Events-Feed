import SwiftUI
import Kingfisher

struct ConcertCardView: View {
    let concert: Concert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            headerView
            
            // Image
            imageView
            
            // Footer
            footerView
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(concert.title)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "location.circle.fill")
                        .font(.caption2)
                    Text(concert.venue.city)
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(concert.startDate, style: .date)
                    .font(.caption)
                Text(concert.endDate, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var imageView: some View {
        Group {
            if let imageUrl = concert.imageURL {
                KFImage(imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
                    .cornerRadius(8)
            }
        }
    }
    
    private var footerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(concert.title)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            HStack {
                Text(concert.startDate.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                
                Spacer()
                
                Text(concert.price.formatted)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)

            }
        }
    }
}

//#Preview {
//    ConcertCardView(concert: MockData.getConcerts()[2])
//}
