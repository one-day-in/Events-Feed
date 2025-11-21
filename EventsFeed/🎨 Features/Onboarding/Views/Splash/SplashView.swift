import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    var onComplete: () -> Void
    
    // Виносимо розміри екрана в змінні
    private var screenWidth: CGFloat { UIScreen.main.bounds.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.height }
    
    // Радіус для кругового руху
    private var circleRadius: CGFloat { min(screenWidth, screenHeight) * 0.8 }
    
    // Кути для кругового руху
    @State private var lightAngles: [Double] = []
    
    var body: some View {
        ZStack {
            Color.darkNavy.ignoresSafeArea()
            
            lightSpotsBackground
            spotlights
            centralContent
            lightSpotsForeground
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.skipAnimations()
        }
        .onAppear {
            // Генеруємо кути перед початком анімації
            if lightAngles.isEmpty {
                lightAngles = viewModel.generateLightAngles()
            }
            viewModel.startAnimations()
        }
        .onChange(of: viewModel.animationState) {
            if viewModel.animationState == .completed {
                onComplete()
            }
        }
    }
    
    // MARK: - Центральний контент
    private var centralContent: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("Concert")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(titleGradient)
                    .scaleEffect(0.5 + 0.5 * viewModel.animationProgress)
                    .opacity(viewModel.animationProgress)
                    .shadow(color: .warmOrange.opacity(0.5), radius: 10)
                
                Text("Box")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(titleGradient)
                    .scaleEffect(0.7 + 0.3 * viewModel.animationProgress)
                    .opacity(viewModel.animationProgress * 0.8)
            }
            
            Text("Знайди свій ідеальний концерт")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .opacity(viewModel.animationProgress * 0.6)
                .scaleEffect(0.9 + 0.1 * viewModel.animationProgress)
        }
        .padding(.horizontal, 40)
    }
        
    private var titleGradient: LinearGradient {
        LinearGradient(
            colors: [.warmOrange, .pinkPurple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Світлові плями на задньому плані
    private var lightSpotsBackground: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.warmOrange.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: -screenWidth * 0.3, y: -screenHeight * 0.2)
                .blur(radius: 40)
                .opacity(viewModel.lightAnimationProgress)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.pinkPurple.opacity(0.25), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 250, height: 250)
                .offset(x: screenWidth * 0.35, y: screenHeight * 0.25)
                .blur(radius: 35)
                .opacity(viewModel.lightAnimationProgress * 0.8)
        }
    }
    
    // MARK: - Прожектори
    private var spotlights: some View {
        ZStack {
            SpotlightView(
                angle: viewModel.leftSpotlightAngle,
                width: viewModel.leftSpotlightWidth,
                color: .warmOrange,
                opacity: 0.7,
                blurRadius: 25,
                offset: CGSize(width: -screenWidth * 0.4, height: 0),
                animationProgress: viewModel.lightAnimationProgress
            )
            
            SpotlightView(
                angle: viewModel.rightSpotlightAngle,
                width: viewModel.rightSpotlightWidth,
                color: .pinkPurple,
                opacity: 0.6,
                blurRadius: 30,
                offset: CGSize(width: screenWidth * 0.4, height: 0),
                animationProgress: viewModel.lightAnimationProgress
            )
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .goldenYellow.opacity(0.4 * viewModel.lightAnimationProgress),
                            .warmOrange.opacity(0.2 * viewModel.lightAnimationProgress),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300 * viewModel.lightAnimationProgress
                    )
                )
                .blur(radius: 30)
                .scaleEffect(0.8 + 0.2 * viewModel.lightAnimationProgress)
        }
    }
    
    // MARK: - Світлові плями на передньому плані (круговий рух)
    private var lightSpotsForeground: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                if lightAngles.indices.contains(index) {
                    let angle = lightAngles[index]
                    let offset = viewModel.calculateCircularOffset(
                        angle: angle,
                        radius: circleRadius,
                        progress: viewModel.lightAnimationProgress
                    )
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    viewModel.randomLightColor().opacity(0.6),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .offset(offset)
                        .scaleEffect(0.5 + 0.5 * viewModel.lightAnimationProgress)
                        .blur(radius: 8)
                        .opacity(viewModel.lightAnimationProgress)
                }
            }
        }
        .animation(.easeOut(duration: 2.5), value: viewModel.lightAnimationProgress)
    }
}

#Preview {
    SplashView {
        print("Splash completed")
    }
}
