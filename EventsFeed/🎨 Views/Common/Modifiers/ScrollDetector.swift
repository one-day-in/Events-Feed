import SwiftUI

/// Напрямок прокрутки
public enum ScrollDirection {
    case up
    case down
}

/// Детектор жесту прокрутки користувача
struct UserScrollDetector: ViewModifier {
    private let onUserScroll: (ScrollDirection) -> Void
    @State private var lastOffset: CGFloat = 0
    
    // Збільшений поріг для ігнорування баунсу
    private let scrollThreshold: CGFloat = 8
    
    init(onUserScroll: @escaping (ScrollDirection) -> Void) {
        self.onUserScroll = onUserScroll
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            lastOffset = proxy.frame(in: .global).minY
                        }
                        .onChange(of: proxy.frame(in: .global).minY) { oldValue, newValue in
                            let delta = newValue - lastOffset
                            
                            // Збільшений поріг для ігнорування баунсу
                            guard abs(delta) > scrollThreshold else { return }
                            
                            let screenHeight = UIScreen.main.bounds.height
                            let contentHeight = proxy.size.height
                            
                            // Визначаємо чи ми в баунсі
                            let isAtTop = newValue >= 0
                            let isAtBottom = contentHeight + newValue <= screenHeight
                            
                            // Ігноруємо скрол вгору коли на самому верху
                            if isAtTop && delta < 0 { return }
                            
                            // Ігноруємо скрол вниз коли в самому низу
                            if isAtBottom && delta > 0 { return }
                            
                            let direction: ScrollDirection = delta > 0 ? .down : .up
                            onUserScroll(direction)
                            lastOffset = newValue
                        }
                }
            )
    }
}

/// Детектор досягнення нижньої частини контенту
struct BottomScrollDetector: ViewModifier {
    private let threshold: CGFloat
    private let action: () -> Void
    @State private var hasTriggered = false
    
    init(threshold: CGFloat, action: @escaping () -> Void) {
        self.threshold = threshold
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.frame(in: .global).minY) { oldValue, newValue in
                            checkIfNearBottom(proxy: proxy)
                        }
                }
            )
    }
    
    private func checkIfNearBottom(proxy: GeometryProxy) {
        let screenHeight = UIScreen.main.bounds.height
        let scrollViewTop = proxy.frame(in: .global).minY
        let contentHeight = proxy.size.height
        
        // Розраховуємо скільки контенту залишилось внизу
        let remainingContent = contentHeight + scrollViewTop - screenHeight
        
        // Спрацьовуємо коли залишилось менше ніж threshold до кінця
        guard remainingContent < threshold, !hasTriggered else { return }
        
        hasTriggered = true
        action()
        
        // Запобігаємо множинним викликам
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            hasTriggered = false
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Відслідковує жест прокрутки користувача
    /// - Parameter action: Closure, який викликається з напрямком прокрутки
    func onUserScroll(_ action: @escaping (ScrollDirection) -> Void) -> some View {
        self.modifier(UserScrollDetector(onUserScroll: action))
    }
    
    /// Виявляє досягнення нижньої частини контенту
    /// - Parameters:
    ///   - threshold: Відстань від нижнього краю для спрацьовування
    ///   - action: Closure, який викликається при досягненні нижньої частини
    func onBottomScroll(threshold: CGFloat = 100, action: @escaping () -> Void) -> some View {
        self.modifier(BottomScrollDetector(threshold: threshold, action: action))
    }
}
