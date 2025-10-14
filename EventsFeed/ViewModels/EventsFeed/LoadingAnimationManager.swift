import SwiftUI
import Combine

@MainActor
final class LoadingAnimationManager: ObservableObject {
    // MARK: - Published Properties
    @Published var logoRotation: Double = 0
    @Published var logoScale: CGFloat = 0.8
    @Published var logoOpacity: Double = 0
    
    @Published var textOpacity: Double = 0
    @Published var textOffset: CGFloat = 20
    
    @Published var progressOpacity: Double = 0
    @Published var pulseScale: CGFloat = 1.0
    
    @Published var particles: [Particle] = []
    @Published var circlesOpacity: Double = 0
    
    @Published var backgroundGradientRotation: Double = 0
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var particleTimer: Timer?
    
    // MARK: - Initialization
    init() {
        setupParticles()
    }
    
    deinit {
        particleTimer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    func startAnimation() {
        // 1. Анімація появи логотипу
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            logoOpacity = 1
            logoScale = 1.0
        }
        
        // 2. Обертання логотипу
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            logoRotation = 360
        }
        
        // 3. Пульсація
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
        }
        
        // 4. Текст з затримкою
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.textOpacity = 1
                self.textOffset = 0
            }
        }
        
        // 5. Прогрес бар з затримкою
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.progressOpacity = 1
            }
        }
        
        // 6. Кола з затримкою
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.6)) {
                self.circlesOpacity = 0.3
            }
        }
        
        // 7. Градієнт фону
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            backgroundGradientRotation = 360
        }
        
        // 8. Запуск частинок
        startParticleAnimation()
    }
    
    func startExitAnimation(completion: @escaping () -> Void) {
        // Швидке зникнення
        withAnimation(.easeIn(duration: 0.3)) {
            logoOpacity = 0
            logoScale = 1.2
            textOpacity = 0
            progressOpacity = 0
            circlesOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion()
        }
    }
    
    func reset() {
        logoRotation = 0
        logoScale = 0.8
        logoOpacity = 0
        textOpacity = 0
        textOffset = 20
        progressOpacity = 0
        pulseScale = 1.0
        circlesOpacity = 0
        backgroundGradientRotation = 0
        particles.removeAll()
        particleTimer?.invalidate()
    }
    
    // MARK: - Private Methods
    
    private func setupParticles() {
        particles = (0..<20).map { index in
            Particle(
                id: index,
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.1...0.4),
                speed: Double.random(in: 20...60)
            )
        }
    }
    
    private func startParticleAnimation() {
        particleTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            Task { @MainActor in
                for index in self.particles.indices {
                    self.particles[index].y -= self.particles[index].speed * 0.05
                    
                    // Респавн частинок знизу
                    if self.particles[index].y < -10 {
                        self.particles[index].y = UIScreen.main.bounds.height + 10
                        self.particles[index].x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Types

struct Particle: Identifiable {
    let id: Int
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let opacity: Double
    let speed: Double
}
