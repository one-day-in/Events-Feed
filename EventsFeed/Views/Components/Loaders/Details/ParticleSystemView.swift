// Views/App/Loading/Components/ParticleSystemView.swift
import SwiftUI

struct ParticleSystemView: View {
    let particles: [Particle]
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .opacity(particle.opacity)
                    .blur(radius: 1)
            }
        }
    }
}

#Preview {
    ParticleSystemView(particles: [
        Particle(id: 0, x: 100, y: 200, size: 4, opacity: 0.3, speed: 30),
        Particle(id: 1, x: 200, y: 400, size: 6, opacity: 0.2, speed: 40),
        Particle(id: 2, x: 300, y: 300, size: 3, opacity: 0.4, speed: 25)
    ])
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
}
