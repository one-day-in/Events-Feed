// Views/App/Loading/LoadingView.swift
import SwiftUI

struct LoadingView: View {
    @StateObject private var animationManager = LoadingAnimationManager()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Animated Background
            backgroundView
            
            VStack(spacing: 40) {
                Spacer()
                
                // Main Content
                VStack(spacing: 32) {
                    // Animated Logo with Pulsing Circles
                    ZStack {
                        PulsingCirclesView(
                            opacity: animationManager.circlesOpacity,
                            pulseScale: animationManager.pulseScale
                        )
                        
                        AnimatedLogoView(
                            rotation: animationManager.logoRotation,
                            scale: animationManager.logoScale,
                            opacity: animationManager.logoOpacity,
                            pulseScale: animationManager.pulseScale
                        )
                    }
                    
                    // Text Content
                    VStack(spacing: 12) {
                        Text("ConcertFlow")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(animationManager.textOpacity)
                            .offset(y: animationManager.textOffset)
                        
                        Text("Завантаження ваших подій...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .opacity(animationManager.textOpacity)
                            .offset(y: animationManager.textOffset)
                    }
                    
                    // Progress Indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.2)
                        .opacity(animationManager.progressOpacity)
                }
                
                Spacer()
                
                // Version
                Text("Версія 1.0.1")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.6))
                    .opacity(animationManager.textOpacity)
            }
            .padding(.horizontal, 40)
            
            // Particle System
            ParticleSystemView(particles: animationManager.particles)
        }
        .ignoresSafeArea()
        .onAppear {
            animationManager.startAnimation()
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundView: some View {
        ZStack {
            // Base color
            Color(.systemBackground)
            
            // Animated gradient overlay
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.15),
                    Color.purple.opacity(0.1),
                    Color.clear
                ],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .rotationEffect(.degrees(animationManager.backgroundGradientRotation))
            .blur(radius: 30)
        }
    }
}

#Preview {
    LoadingView()
}

#Preview("Dark Mode") {
    LoadingView()
        .preferredColorScheme(.dark)
}
