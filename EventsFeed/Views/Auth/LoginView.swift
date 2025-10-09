import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionManager: CoordinatedSessionManager
    @State private var isSigningIn = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Events Feed")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Увійдіть щоб переглянути події")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: handleSignIn) {
                HStack {
                    if isSigningIn {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "g.circle.fill")
                        Text("Увійти з Google")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isSigningIn)
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func handleSignIn() {
        isSigningIn = true
        Task {
            await sessionManager.signIn()
            isSigningIn = false
        }
    }
}

#Preview {
    let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
    
    LoginView()
        .environmentObject(sessionManager)
}
