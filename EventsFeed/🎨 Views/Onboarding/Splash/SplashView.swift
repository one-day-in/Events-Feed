import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    var onSkip: () -> Void
    
    var body: some View {
        ZStack {
            // Фон
            backgroundView
            
            // Контейнер лавової лампи з вмістом всередині
            lavaLampContainerWithContent
            
            // Лавові бульбашки
            lavaBubblesView
        }
        .onAppear {
            viewModel.startAnimations()
        }
        .onTapGesture {
            onSkip()
        }
        .contentShape(Rectangle())
    }
    
    // MARK: - Компоненти
    
    private var backgroundView: some View {
        Color(red: 0.05, green: 0.03, blue: 0.08)
            .ignoresSafeArea()
    }
    
    private var lavaLampContainerWithContent: some View {
        let containerWidth = min(UIScreen.main.bounds.width * 0.8, 320)
        let containerHeight = min(UIScreen.main.bounds.height * 0.7, 500)
        
        return ZStack {
            // Основа колонки
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.1, blue: 0.25),
                            Color(red: 0.08, green: 0.05, blue: 0.15),
                            Color(red: 0.12, green: 0.08, blue: 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: containerWidth, height: containerHeight)
            
            // Динамік
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .black.opacity(0.8),
                            .black.opacity(0.6),
                            Color(red: 0.3, green: 0.2, blue: 0.4)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: containerWidth * 0.3
                    )
                )
                .frame(width: containerWidth * 0.6, height: containerWidth * 0.6)
                .overlay(
                    Circle()
                        .stroke(LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                        .blur(radius: 2)
                )
            
            // Сітка динаміка
            ForEach(0..<8) { index in
                Circle()
                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: containerWidth * 0.45 - CGFloat(index) * (containerWidth * 0.06),
                           height: containerWidth * 0.45 - CGFloat(index) * (containerWidth * 0.06))
            }
            
            // ВІНІЛОВА ПЛАСТИНКА всередині динаміка
            vinylRecordView
                .scaleEffect(0.7) // Трохи зменшуємо для гарного розміщення
            
            // ТЕКСТ всередині контейнера
            textContentView
                .offset(y: containerHeight * 0.25) // Зміщуємо текст нижче
            
            // Неонове підсвічування
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [.purple, .blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: containerWidth, height: containerHeight)
                .blur(radius: 1)
        }
        .shadow(color: .purple.opacity(0.4), radius: 30, x: 0, y: 0)
        .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 10)
    }
    
    private var lavaBubblesView: some View {
        ForEach(viewModel.splash.bubbles) { bubble in
            LavaBubbleView(bubble: bubble)
        }
    }
    
    private var vinylRecordView: some View {
        let recordSize = min(UIScreen.main.bounds.width * 0.3, 140) // Трохи менший розмір
        
        return ZStack {
            // Основа пластинки
            recordBase(recordSize: recordSize)
            
            // Концентричні кола пластинки
            recordGrooves(recordSize: recordSize)
            
            // Центральна етикетка
            recordLabel(recordSize: recordSize)
            
            // Отвір у центрі
            recordCenterHole(recordSize: recordSize)
            
            // Логотип на етикетці
            recordLogo(recordSize: recordSize)
        }
    }
    
    private func recordBase(recordSize: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.2, green: 0.2, blue: 0.25),
                        Color(red: 0.1, green: 0.1, blue: 0.15),
                        .black
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: recordSize / 2
                )
            )
            .frame(width: recordSize, height: recordSize)
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.gray.opacity(0.6), .black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: max(2, recordSize * 0.017)
                    )
            )
            .shadow(color: .black.opacity(0.5), radius: recordSize * 0.1, x: 0, y: 5)
    }
    
    private func recordGrooves(recordSize: CGFloat) -> some View {
        ForEach(0..<6) { index in
            let radius = recordSize * 0.7 - CGFloat(index) * (recordSize * 0.08)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [.gray.opacity(0.4), .black.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: max(1, recordSize * 0.008)
                )
                .frame(width: radius, height: radius)
        }
    }
    
    private func recordLabel(recordSize: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.8, green: 0.7, blue: 0.3),
                        Color(red: 0.6, green: 0.5, blue: 0.2),
                        Color(red: 0.4, green: 0.3, blue: 0.1)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: recordSize * 0.17
                )
            )
            .frame(width: recordSize * 0.33, height: recordSize * 0.33)
            .overlay(
                Circle()
                    .stroke(.black.opacity(0.3), lineWidth: max(1, recordSize * 0.008))
            )
    }
    
    private func recordCenterHole(recordSize: CGFloat) -> some View {
        Circle()
            .fill(.black)
            .frame(width: recordSize * 0.067, height: recordSize * 0.067)
    }
    
    private func recordLogo(recordSize: CGFloat) -> some View {
        Image(systemName: "music.note")
            .font(.system(size: recordSize * 0.13, weight: .bold))
            .foregroundColor(.white.opacity(0.9))
            .scaleEffect(viewModel.splash.logoScale)
    }
    
    private var textContentView: some View {
        VStack(spacing: 12) {
            Text("ConcertFlow")
                .font(.custom("DancingScript-Regular", size: 32)) // Трохи менший розмір
                .foregroundColor(.white)
                .opacity(viewModel.splash.textOpacity)
                .offset(y: viewModel.splash.textOffset)
            
            Text("Завантаження...")
                .font(.custom("DancingScript-Regular", size: 16))
                .foregroundColor(.white.opacity(0.7))
                .opacity(viewModel.splash.textOpacity)
                .offset(y: viewModel.splash.textOffset)
        }
    }
}

// Візуалізація лавової бульбашки
struct LavaBubbleView: View {
    let bubble: LavaBubble
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        bubble.color,
                        bubble.color.opacity(0.7),
                        bubble.color.opacity(0.3)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: bubble.size / 2
                )
            )
            .frame(width: bubble.size, height: bubble.size)
            .position(bubble.position)
            .blur(radius: 8)
            .blendMode(.screen)
    }
}

#Preview {
    SplashView {
        print("tapped")
    }
}
