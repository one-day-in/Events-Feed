import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                // Header з анімацією
                VStack(spacing: 32) {
                    // Логотип з кругами
                    ZStack {
                        PulsingCirclesView(
                            opacity: 0.3, // Фіксована прозорість для логіну
                            pulseScale: 1.0
                        )
                        
                        Image(systemName: "music.mic.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    // Текст
                    VStack(spacing: 12) {
                        Text("ConcertFlow")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Увійдіть, щоб переглядати концерти та події")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 80)
                .padding(.bottom, 60)
                
                Spacer()
                
                // Кнопки авторизації
                VStack(spacing: 16) {
                    AuthButtonView(
                        provider: .google,
                        isLoading: sessionManager.isLoading
                    ) {
                        Task {
                            await sessionManager.signIn(with: .google)
                        }
                    }
                    
                    AuthButtonView(
                        provider: .apple,
                        isLoading: sessionManager.isLoading
                    ) {
                        Task {
                            await sessionManager.signIn(with: .apple)
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Версія додатка
                Text("Версія 1.0.1")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.6))
                    .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(!sessionManager.isLoading)
    }
    
    // MARK: - Subviews
    
    private var backgroundView: some View {
        ZStack {
            // Base color
            Color(.systemBackground)
            
            // Gradient overlay як в LoadingView
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color.clear
                ],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .blur(radius: 20)
        }
    }
}

#Preview {
    let sessionManager = DIContainer.shared.resolve(SessionManager.self)
    
    return LoginView()
        .environmentObject(sessionManager)
}

#Preview("Dark Mode") {
    let sessionManager = DIContainer.shared.resolve(SessionManager.self)
    
    return LoginView()
        .environmentObject(sessionManager)
        .preferredColorScheme(.dark)
}
