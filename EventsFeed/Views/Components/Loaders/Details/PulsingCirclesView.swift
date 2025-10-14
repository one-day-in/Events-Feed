// Views/App/Loading/Components/PulsingCirclesView.swift
import SwiftUI

struct PulsingCirclesView: View {
    let opacity: Double
    let pulseScale: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100 + CGFloat(index * 30), height: 100 + CGFloat(index * 30))
                    .scaleEffect(pulseScale - CGFloat(index) * 0.05)
                    .opacity(opacity * (1.0 - Double(index) * 0.2))
            }
        }
    }
}

#Preview {
    PulsingCirclesView(opacity: 0.3, pulseScale: 1.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
}
