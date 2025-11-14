import SwiftUI

struct SpotlightView: View {
    // MARK: - Configurable Properties
    var angle: Double = 0
    var width: CGFloat = 60
    var height: CGFloat = 200
    var startRadius: CGFloat = 10
    var endRadius: CGFloat = 100
    var color: Color = .orange
    var opacity: Double = 0.8
    var blurRadius: CGFloat = 20
    var scale: Double = 1.0
    var offset: CGSize = .zero
    var animationProgress: Double = 1.0
    
    // MARK: - Body
    var body: some View {
        SpotlightShape(angle: angle, width: width)
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(opacity * animationProgress),
                        color.opacity(opacity * 0.4 * animationProgress),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .scaleEffect(scale)
            .offset(offset)
            .blur(radius: blurRadius)
    }
}

// MARK: - Flexible Shape
struct SpotlightShape: Shape {
    var angle: Double = 0
    var width: CGFloat = 60
    var startRadius: CGFloat = 10
    var endRadius: CGFloat = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Конвертуємо кути в радіани
        let startAngleRad = (angle - width/2) * .pi / 180
        let endAngleRad = (angle + width/2) * .pi / 180
        
        path.move(to: center)
        
        // Маленька дуга на початку
        path.addArc(
            center: center,
            radius: startRadius,
            startAngle: .radians(startAngleRad),
            endAngle: .radians(endAngleRad),
            clockwise: false
        )
        
        // Плавне розширення до кінця
        let endStartPoint = CGPoint(
            x: center.x + endRadius * cos(CGFloat(startAngleRad)),
            y: center.y + endRadius * sin(CGFloat(startAngleRad))
        )
        
        _ = CGPoint(
            x: center.x + endRadius * cos(CGFloat(endAngleRad)),
            y: center.y + endRadius * sin(CGFloat(endAngleRad))
        )
        
        // Плавні криві для розширення
        path.addCurve(
            to: endStartPoint,
            control1: CGPoint(
                x: center.x + (startRadius + endRadius) * 0.3 * cos(CGFloat(startAngleRad)),
                y: center.y + (startRadius + endRadius) * 0.3 * sin(startAngleRad)
            ),
            control2: CGPoint(
                x: center.x + (startRadius + endRadius) * 0.7 * cos(CGFloat(startAngleRad)),
                y: center.y + (startRadius + endRadius) * 0.7 * sin(startAngleRad)
            )
        )
        
        // Велика дуга в кінці
        path.addArc(
            center: center,
            radius: endRadius,
            startAngle: .radians(startAngleRad),
            endAngle: .radians(endAngleRad),
            clockwise: true
        )
        
        // Замикання форми
        path.addCurve(
            to: CGPoint(
                x: center.x + startRadius * cos(CGFloat(endAngleRad)),
                y: center.y + startRadius * sin(endAngleRad)
            ),
            control1: CGPoint(
                x: center.x + (startRadius + endRadius) * 0.7 * cos(CGFloat(endAngleRad)),
                y: center.y + (startRadius + endRadius) * 0.7 * sin(endAngleRad)
            ),
            control2: CGPoint(
                x: center.x + (startRadius + endRadius) * 0.3 * cos(CGFloat(endAngleRad)),
                y: center.y + (startRadius + endRadius) * 0.3 * sin(endAngleRad)
            )
        )
        
        return path
    }
}
