// Shimmer.swift
import SwiftUI

struct ShimmerModifier: ViewModifier {
    let active: Bool
    let duration: Double
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .modifier(AnimatedMask(phase: phase))
            .opacity(active ? 1 : 0)
            .onAppear {
                guard active else { return }
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
    
    struct AnimatedMask: AnimatableModifier {
        var phase: CGFloat = 0
        
        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }
        
        func body(content: Content) -> some View {
            content
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                .black.opacity(0.3),
                                .black,
                                .black.opacity(0.3)
                            ]
                        ),
                        startPoint: UnitPoint(x: -1.0 + phase * 2, y: 0.5),
                        endPoint: UnitPoint(x: phase * 2, y: 0.5)
                    )
                )
        }
    }
}

extension View {
    func shimmer(
        active: Bool = true,
        duration: Double = 1.2
    ) -> some View {
        self.modifier(ShimmerModifier(active: active, duration: duration))
    }
}

#Preview("PlaceHolder") {
    ConcertCardPlaceholderView()
}

