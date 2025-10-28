import SwiftUI

struct Splash {
    var logoScale: CGFloat = 1.0
    var glowOpacity: Double = 0.3
    var textOpacity: Double = 0.0
    var textOffset: CGFloat = 20
    var bubbles: [LavaBubble] = []
    var containerWobble: Double = 0.0
}

struct LavaBubble: Identifiable, Equatable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var targetPosition: CGPoint
    var speed: Double
}

// MARK: - Helpers
extension Color {
    static func randomLavaColor() -> Color {
        let lavaColors: [Color] = [
            Color(red: 0.9, green: 0.2, blue: 0.1),   // Червоний
            Color(red: 0.8, green: 0.4, blue: 0.1),   // Оранжевий
            Color(red: 0.7, green: 0.2, blue: 0.5),   // Пурпурний
            Color(red: 0.6, green: 0.1, blue: 0.3),   // Бордовий
            Color(red: 0.8, green: 0.3, blue: 0.2),   // Кораловий
        ]
        return lavaColors.randomElement() ?? Color(red: 0.8, green: 0.3, blue: 0.2)
    }
}
