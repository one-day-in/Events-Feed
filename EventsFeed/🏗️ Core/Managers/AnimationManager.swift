import Foundation
import SwiftUI

@MainActor
final class AnimationManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var splashAnimationState = SplashAnimationState()
    @Published var isAnimating = false
    @Published var isSplashComplete = false
    
    // MARK: - Configuration
    private let minSplashDuration: TimeInterval = 4.0 // Мінімальна тривалість сплеш-екрану
    private let animationCompletionDelay: TimeInterval = 0.5 // Затримка перед завершенням
    
    // MARK: - Private Properties
    private var animationTasks: [Task<Void, Never>] = []
    private var timers: [Timer] = []
    private var splashStartTime: Date?
    
    // MARK: - Splash Animation Methods
    func startSplashAnimation() async {
        guard !isAnimating else { return }
        
        isAnimating = true
        isSplashComplete = false
        splashStartTime = Date()
        resetSplashAnimation()
        
        // Запускаємо основну логіку анімації
        await startSplashAnimationLogic()
        
        // Запускаємо таймер мінімальної тривалості
        await ensureMinimumSplashDuration()
    }
    
    func stopAnimations() async {
        guard isAnimating else { return }
        
        // Скасовуємо всі задачі
        animationTasks.forEach { $0.cancel() }
        animationTasks.removeAll()
        
        // Зупиняємо таймери
        timers.forEach { $0.invalidate() }
        timers.removeAll()
        
        // Плавно завершуємо анімації
        await completeSplashAnimation()
    }
    
    func skipSplashAnimation() async {
        await stopAnimations()
    }
    
    // MARK: - Private Animation Methods
    private func startSplashAnimationLogic() async {
        // Запускаємо всі анімації паралельно
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.startLogoPulseAnimation() }
            group.addTask { await self.startBackgroundCirclesAnimation() }
            group.addTask { await self.startTextAppearAnimation() }
        }
    }
    
    private func ensureMinimumSplashDuration() async {
        guard let startTime = splashStartTime else { return }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        let remainingTime = max(0, minSplashDuration - elapsedTime)
        
        if remainingTime > 0 {
            try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
        }
        
        // Позначаємо анімацію як завершену, якщо ще не завершена
        if isAnimating && !isSplashComplete {
            await completeSplashAnimation()
        }
    }
    
    private func completeSplashAnimation() async {
        // Плавно завершуємо анімації
        withAnimation(.easeOut(duration: animationCompletionDelay)) {
            splashAnimationState.logoScale = 1.0
            splashAnimationState.glowOpacity = 0.0
            splashAnimationState.textOpacity = 0.0
            splashAnimationState.textOffset = 20
            splashAnimationState.circles = splashAnimationState.circles.map { circle in
                var updatedCircle = circle
                updatedCircle.opacity = 0.0
                return updatedCircle
            }
        }
        
        // Чекаємо завершення анімації
        try? await Task.sleep(nanoseconds: UInt64(animationCompletionDelay * 1_000_000_000))
        
        isAnimating = false
        isSplashComplete = true
    }
    
    private func resetSplashAnimation() {
        splashAnimationState = SplashAnimationState()
    }
    
    private func startLogoPulseAnimation() async {
        // Пульсація логотипу
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            splashAnimationState.logoScale = 1.2
            splashAnimationState.glowOpacity = 0.6
        }
    }
    
    private func startBackgroundCirclesAnimation() async {
        // Генерація початкових кіл
        splashAnimationState.circles = (0..<6).map { _ in
            CircleData(
                scale: CGFloat.random(in: 0.5...2.0),
                opacity: Double.random(in: 0.1...0.3),
                offset: CGSize(
                    width: CGFloat.random(in: -150...150),
                    height: CGFloat.random(in: -150...150)
                )
            )
        }
        
        // Анімація кіл
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, self.isAnimating else { return }
                
                withAnimation(.easeInOut(duration: 4.0)) {
                    self.splashAnimationState.circles = self.splashAnimationState.circles.map { circle in
                        var newCircle = circle
                        newCircle.scale = CGFloat.random(in: 0.5...2.5)
                        newCircle.opacity = Double.random(in: 0.05...0.4)
                        return newCircle
                    }
                }
            }
        }
        
        timers.append(timer)
    }
    
    private func startTextAppearAnimation() async {
        // Затримка перед появою тексту
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 секунди
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            splashAnimationState.textOpacity = 1.0
            splashAnimationState.textOffset = 0
        }
    }
}

// MARK: - Animation State Models
struct SplashAnimationState {
    var logoScale: CGFloat = 1.0
    var glowOpacity: Double = 0.3
    var textOpacity: Double = 0.0
    var textOffset: CGFloat = 20
    var circles: [CircleData] = []
}

struct CircleData: Identifiable {
    let id = UUID()
    var scale: CGFloat
    var opacity: Double
    var offset: CGSize
}
