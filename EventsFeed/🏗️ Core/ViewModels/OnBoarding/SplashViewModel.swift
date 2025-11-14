import SwiftUI

enum AnimationState {
    case initial
    case animating
    case completed
}

class SplashViewModel: ObservableObject {
    @Published var animationProgress: Double = 0.0
    @Published var lightAnimationProgress: Double = 0.0
    @Published var animationState: AnimationState = .initial
    
    // Налаштування анімації
    let mainAnimationDuration: Double = 1.0
    let lightAnimationDuration: Double = 3.0
    let totalAnimationDuration: Double = 4.0
    let skipAnimationDuration: Double = 1.5
    
    // Налаштування прожекторів
    let leftSpotlightAngle: Double = 45
    let leftSpotlightWidth: CGFloat = 160
    let rightSpotlightAngle: Double = -45
    let rightSpotlightWidth: CGFloat = 265
    
    // Для кругового руху світлових плям
    private var lightAngles: [Double] = []
    
    // MARK: - Допоміжні функції для світлових плям
    func generateLightAngles() -> [Double] {
        guard lightAngles.isEmpty else { return lightAngles }
        
        var angles: [Double] = []
        for index in 0..<8 {
            let angle = Double(index) * (360.0 / 8.0) + Double.random(in: -15...15)
            angles.append(angle)
        }
        lightAngles = angles
        return angles
    }

    func calculateCircularOffset(angle: Double, radius: CGFloat, progress: Double) -> CGSize {
        let radians = angle * .pi / 180.0
        let distance = radius * progress
        return CGSize(
            width: cos(radians) * distance,
            height: sin(radians) * distance
        )
    }

    func randomLightColor() -> Color {
        let colors: [Color] = [.warmOrange, .pinkPurple, .goldenYellow]
        return colors.randomElement() ?? .warmOrange
    }
        
    func startAnimations() {
        animationState = .animating
        
        // Анімація головного контенту
        withAnimation(.easeOut(duration: mainAnimationDuration)) {
            animationProgress = 1.0
        }
        
        // Анімація світла - з затримкою для кругового руху
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: self.lightAnimationDuration - 0.3)) {
                self.lightAnimationProgress = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) {
            if self.animationState == .animating {
                self.animationState = .completed
            }
        }
    }
    
    func skipAnimations() {
        // Негайно завершуємо анімацію
        withAnimation(.easeOut(duration: skipAnimationDuration)) {
            animationProgress = 1.0
            lightAnimationProgress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + skipAnimationDuration) {
            self.animationState = .completed
        }
    }
    
    func reset() {
        animationProgress = 0.0
        lightAnimationProgress = 0.0
        animationState = .initial
        lightAngles = []
    }
}
