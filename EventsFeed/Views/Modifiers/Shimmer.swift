import SwiftUI

struct ShimmerModifier: ViewModifier {
    let active: Bool
    let duration: Double
    
    @State private var intensity: Double = 0.3
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .black.opacity(0.1),
                                .white.opacity(0.6),
                                .white.opacity(0.9),
                                .white.opacity(0.6),
                                .black.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(intensity)
                    .mask(content)
                    .blendMode(.screen)
            )
            .onAppear {
                if active {
                    withAnimation(
                        .easeInOut(duration: duration)
                            .repeatForever(autoreverses: true)
                    ) {
                        intensity = 0.8
                    }
                }
            }
    }
}

#Preview {
    Rectangle()
        .fill(Color.blue)
        .frame(width: 300, height: 200)
        .shimmer()
        .padding()
}


extension View {
    func shimmer(
        active: Bool = true,
        duration: Double = 1.5,
        bounce: Bool = false
    ) -> some View {
        self
            .modifier(ShimmerModifier(
                active: active,
                duration: duration,
            ))
    }
}

#Preview("PlaceHolder") {
    ConcertCardPlaceholderView()
}

