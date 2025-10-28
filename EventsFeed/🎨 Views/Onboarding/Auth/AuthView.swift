import SwiftUI

struct AuthView: View {
    let onGoogleSignIn: () -> Void
    let onAppleSignIn: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 20) {
                AuthButton(
                    title: "Увійти через Google",
                    icon: "globe",
                    color: .white,
                    textColor: .black
                ) {
                    onGoogleSignIn()
                }

                AuthButton(
                    title: "Увійти через Apple",
                    icon: "applelogo",
                    color: .black,
                    textColor: .white
                ) {
                    onAppleSignIn()
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
            .background(
                LinearGradient(
                    colors: [Color.black.opacity(0.3), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea(edges: .bottom)
            )
        }
        .allowsHitTesting(true)
    }
}

#Preview {
    AuthView(
        onGoogleSignIn: {
            print("Google sign in tapped")
        },
        onAppleSignIn: {
            print("Apple sign in tapped")
        }
    )
    .background(
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    )
}
