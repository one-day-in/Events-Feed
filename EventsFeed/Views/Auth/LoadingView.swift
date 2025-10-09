import SwiftUI

struct LoadingView: View {
    @State private var isRotating = false
    @State private var showContent = false
    @State private var scaleUp = false
    @State private var fadeOut = false
    @State private var logoScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "music.note.list")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                    .scaleEffect(logoScale) // Додаємо масштабування
                    .opacity(fadeOut ? 0 : 1)
                    .animation(
                        .linear(duration: 2.0)
                        .repeatForever(autoreverses: false),
                        value: isRotating
                    )
                
                if !scaleUp {
                    VStack(spacing: 8) {
                        Text("Events Feed")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 10)
                        
                        Text("Завантаження...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 10)
                    }
                }
                            
                Spacer()
            }
        }
        .opacity(fadeOut ? 0 : 1)
        .onAppear {
            startInitialAnimation()
        }
    }
    
    private func startInitialAnimation() {
        isRotating = true
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            showContent = true
        }
    }
    
    // Функція для запуску фінальної анімації
    func startExitAnimation(completion: (() -> Void)? = nil) {
        // Спочатку збільшуємо лого
        withAnimation(.easeInOut(duration: 1.5)) {
            logoScale = 8.0
        }

        // Потім встановлюємо стан
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                scaleUp = true
            }
        }
        
        // Потім зникаємо
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 2.6)) {
                fadeOut = true
            }
            
            // Викликаємо completion після завершення анімації
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                completion?()
            }
        }
    }
}

#Preview {
    LoadingView()
}

#Preview("Exit Animation") {
    struct ExitAnimationPreview: View {
        @State private var showLoading = true
        @State private var loadingViewRef: LoadingView?
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.3).ignoresSafeArea()
                
                if showLoading {
                    LoadingView()
                        .onAppear {
                            loadingViewRef = LoadingView()
                            // Симулюємо завершення завантаження через 2 секунди
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                loadingViewRef?.startExitAnimation {
                                    withAnimation {
                                        showLoading = false
                                    }
                                }
                            }
                        }
                } else {
                    VStack {
                        Text("Головний екран")
                            .font(.title)
                        Text("Додаток завантажено")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    return ExitAnimationPreview()
}
