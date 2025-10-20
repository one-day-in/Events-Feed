import SwiftUI

struct SignOutButton: View {
    let onSignOut: () -> Void
    
    var body: some View {
        Button(role: .destructive, action: onSignOut) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Вийти з акаунта")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        SignOutButton {
            print("Sign out tapped")
        }
    }
    .padding()
}
