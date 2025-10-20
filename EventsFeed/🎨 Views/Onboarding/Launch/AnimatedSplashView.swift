import SwiftUI

struct AnimatedSplashView: View {
    let onSplashComplete: () -> Void
    @StateObject private var animationManager = DIContainer.shared.resolve(AnimationManager.self)
    
    var body: some View {
        ZStack {
            // Темний фон
            Color(red: 0.05, green: 0.05, blue: 0.1)
                .ignoresSafeArea()
            
            // Анімовані кола на фоні
            ForEach(animationManager.splashAnimationState.circles) { circle in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .blue.opacity(circle.opacity),
                                .purple.opacity(circle.opacity * 0.5),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .scaleEffect(circle.scale)
                    .offset(circle.offset)
            }
            
            VStack(spacing: 30) {
                // Центральний логотип
                ZStack {
                    // Зовнішнє світіння
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(animationManager.splashAnimationState.glowOpacity), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(animationManager.splashAnimationState.logoScale)
                    
                    // Основний круг
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "music.microphone.circle.fill")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                
                // Текст
                VStack(spacing: 12) {
                    Text("ConcertFlow")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(animationManager.splashAnimationState.textOpacity)
                        .offset(y: animationManager.splashAnimationState.textOffset)
                    
                    Text("Завантаження...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(animationManager.splashAnimationState.textOpacity)
                        .offset(y: animationManager.splashAnimationState.textOffset)
                }
            }
        }
        .onAppear {
            Task {
                await animationManager.startSplashAnimation()
            }
        }
        .onChange(of: animationManager.isSplashComplete) { oldValue, newValue in
            if newValue {
                onSplashComplete()
            }
        }
        .onTapGesture {
            // Користувач може тапнути, щоб пропустити анімацію
            Task {
                await animationManager.skipSplashAnimation()
            }
        }
    }
}

#Preview {
    AnimatedSplashView(onSplashComplete: {})
}
