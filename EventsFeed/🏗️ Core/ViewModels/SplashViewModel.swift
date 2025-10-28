// SplashViewModel.swift
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var splash = Splash()
    
    private let animationDuration: TimeInterval = 1.5
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    func startAnimations() {
        resetSplashAnimation()
        startLogoPulseAnimation()
        startLavaBubblesAnimation()
        startTextAppearAnimation()
        startContainerWobble()
    }
    
    private func resetSplashAnimation() {
        splash = Splash()
    }
    
    private func startLogoPulseAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
            splash.logoScale = 1.1
        }
        
        // Додаємо затримку і запускаємо зворотну анімацію
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                self.splash.logoScale = 1.0
            }
        }
    }
    
    private func startLavaBubblesAnimation() {
        let extendedWidth = screenWidth * 1.5
        let extendedHeight = screenHeight * 1.5
        let offsetX = (extendedWidth - screenWidth) / 2
        let offsetY = (extendedHeight - screenHeight) / 2
        
        // Створюємо лавові бульбашки
        splash.bubbles = (0..<25).map { _ in
            LavaBubble(
                position: CGPoint(
                    x: CGFloat.random(in: -offsetX...extendedWidth - offsetX),
                    y: CGFloat.random(in: -offsetY...extendedHeight - offsetY)
                ),
                size: CGFloat.random(in: 10...200),
                color: Color.randomLavaColor(),
                targetPosition: CGPoint(
                    x: CGFloat.random(in: -offsetX...extendedWidth - offsetX),
                    y: CGFloat.random(in: -offsetY...extendedHeight - offsetY)
                ),
                speed: Double.random(in: 0.3...1.5)
            )
        }
        
        // Запускаємо анімацію руху бульбашок
        startBubblesMovement()
    }
    
    private func startBubblesMovement() {
        withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
            for i in 0..<splash.bubbles.count {
                // Плавно рухаємо бульбашку до цільової позиції
                let bubble = splash.bubbles[i]
                let dx = bubble.targetPosition.x - bubble.position.x
                let dy = bubble.targetPosition.y - bubble.position.y
                
                splash.bubbles[i].position.x += dx * 0.2 * bubble.speed
                splash.bubbles[i].position.y += dy * 0.2 * bubble.speed
                
                // Якщо бульбашка дісталася до цілі - задаємо нову ціль
                if abs(dx) < 10 && abs(dy) < 10 {
                    splash.bubbles[i].targetPosition = CGPoint(
                        x: CGFloat.random(in: 50...screenWidth - 50),
                        y: CGFloat.random(in: 100...screenHeight - 100)
                    )
                }
            }
        }
    }
    
    private func startContainerWobble() {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            splash.containerWobble = 1.0
        }
    }
    
    private func startTextAppearAnimation() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            splash.textOpacity = 1.0
            splash.textOffset = 0
        }
    }
}


