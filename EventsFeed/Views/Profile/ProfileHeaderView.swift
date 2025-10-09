import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 16) {
            if let user = user {
                // Аватар користувача
                if let imageUrl = user.profileImageURL, let url = URL(string: imageUrl) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                }
                
                Text(user.name ?? "Користувач")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(user.email ?? "Невідомий email")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("Користувач не авторизований")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    ProfileHeaderView(user: MockData.getUser())
}
