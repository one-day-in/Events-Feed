import SwiftUI

struct AnimatedLogoView: View {
    let rotation: Double
    let scale: CGFloat
    let opacity: Double
    let pulseScale: CGFloat
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.purple.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 40,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(pulseScale)
            
            // Main logo
            Image(systemName: "music.mic.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .opacity(opacity)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    AnimatedLogoView(
        rotation: 45,
        scale: 1.0,
        opacity: 1.0,
        pulseScale: 1.1
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
}
