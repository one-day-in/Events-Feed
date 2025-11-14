import SwiftUI

struct AdaptiveBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Основний фон
            if colorScheme == .dark {
                Color.darkNavy
            } else {
                LinearGradient(
                    colors: [
                        .adaptiveBackgroundLight1,
                        .adaptiveBackgroundLight2,
                        .adaptiveBackgroundLight3
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            // Liquid ефекти
            liquidEffects///
        }
        .ignoresSafeArea()
    }
    
    private var liquidEffects: some View {
        Group {
            if colorScheme == .dark {
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 400, height: 400)
                    .offset(x: -100, y: -200)
                    .blur(radius: 120)
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 500, height: 500)
                    .offset(x: 150, y: 100)
                    .blur(radius: 50)
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .offset(x: -100, y: -200)
                    .blur(radius: 60)
                
                Circle()
                    .fill(Color.purple.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .offset(x: 150, y: 100)
                    .blur(radius: 50)
            }
        }
    }
}

#Preview {
    AdaptiveBackgroundView()
        .preferredColorScheme(.dark) // Для тестування темної теми
}
