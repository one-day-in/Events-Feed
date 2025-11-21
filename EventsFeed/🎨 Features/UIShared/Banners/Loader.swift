import SwiftUI

struct Loader: View {
    @State private var animationValues: [CGFloat] = Array(repeating: 20.0, count: 7)
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    private let boxWidth: CGFloat = 180
    private let boxHeight: CGFloat = 60
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Еквалайзер
                    HStack(spacing: 3) {
                        ForEach(0..<7, id: \.self) { index in
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 8, height: animationValues[index])
                                .animation(.easeInOut(duration: 0.4), value: animationValues[index])
                        }
                    }
                    .frame(width: boxWidth, height: boxHeight)
                    
                    Text("loading...")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(30)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .transition(.opacity)
        .onReceive(timer) { _ in
            updateAnimation()
        }
    }
    
    private func updateAnimation() {
        for i in 0..<7 {
            animationValues[i] = CGFloat.random(in: 15...35)
        }
    }
}

#Preview {
    Loader()
}
