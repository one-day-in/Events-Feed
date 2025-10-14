import SwiftUI

struct UserInfoCardView: View {
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Інформація про акаунт")
                .font(.headline)
                .foregroundColor(.primary)
            
            if let user = user {
                InfoRow(icon: "person.fill", title: "ID", value: user.id)
                
                if let givenName = user.givenName {
                    InfoRow(icon: "signature", title: "Ім'я", value: givenName)
                }
                
                if let familyName = user.familyName {
                    InfoRow(icon: "textformat", title: "Прізвище", value: familyName)
                }
                
                InfoRow(icon: "envelope.fill", title: "Email", value: user.email ?? "Не вказано")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    UserInfoCardView(user: MockData.getUser())
}
