import SwiftUI

struct EventsFeedView: View {
    @ObservedObject var viewModel: EventsFeedViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var isHeaderVisible = true
    @State private var hasUserScrolled = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        Color.clear
                            .frame(height: 1)
                            .background(GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        updateScrollOffset(geo)
                                    }
                                    .onChange(of: geo.frame(in: .global).minY) {
                                        updateScrollOffset(geo)
                                    }
                            })
                        
                        // Відображаємо шимери під час завантаження
                        if viewModel.isLoadingData {
                            ForEach(0..<5, id: \.self) { _ in
                                ConcertCardPlaceholderView()
                            }
                        } else {
                            // Відображаємо реальні дані після завантаження
                            ForEach(viewModel.filteredConcerts) { concert in
                                ConcertCardView(concert: concert)
                            }
                        }
                    }
                    .padding(.top, 60)
                }
                .refreshable {
                    // await viewModel.refreshConcerts()
                }
                
                // Фіксований хедер - спочатку завжди видимий
                EventsFeedHeaderView()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .offset(y: isHeaderVisible ? 0 : -60)
                    .shadow(color: .black.opacity(hasUserScrolled && scrollOffset < -10 ? 0.3 : 0), radius: 5, x: 0, y: 2)
                    .animation(.spring(response: 0.4, dampingFraction: 1.8), value: isHeaderVisible)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadConcertsIfNeeded()
            // Спочатку хедер завжди видимий
            resetHeaderState()
        }
    }
    
    private func resetHeaderState() {
        isHeaderVisible = true
        hasUserScrolled = false
        scrollOffset = 0
        lastScrollOffset = 0
    }
    
    private func loadConcertsIfNeeded() {
        if viewModel.concerts.isEmpty && !viewModel.isLoadingData {
            Task {
                await viewModel.loadConcerts()
            }
        }
    }
    
    private func updateScrollOffset(_ geometry: GeometryProxy) {
        let offset = geometry.frame(in: .global).minY
        DispatchQueue.main.async {
            // Визначаємо напрямок скролу
            let scrollDirection: ScrollDirection = offset > lastScrollOffset ? .up : .down
            let scrollDelta = abs(offset - lastScrollOffset)
            
            // Позначаємо, що користувач почав скролити
            if scrollDelta > 2 && !hasUserScrolled {
                hasUserScrolled = true
            }
            
            // Логіка показу/приховування хедера тільки після початку скролу
            if hasUserScrolled {
                if scrollDirection == .down && scrollDelta > 3 && offset < -10 {

                    isHeaderVisible = false
                } else if scrollDirection == .up && scrollDelta > 3 {
                    // Скролимо вверх - показуємо хедер
                    isHeaderVisible = true
                }
            }
            
            // Оновлюємо offset'и
            lastScrollOffset = offset
            scrollOffset = offset
        }
    }
}

// Допоміжний enum для напрямку скролу
enum ScrollDirection {
    case up
    case down
}

#Preview {
    let viewModel = DIContainer.shared.resolve(EventsFeedViewModel.self)
    let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
    
    EventsFeedView(viewModel: viewModel)
        .environmentObject(sessionManager)
}

#Preview("Loading State") {
    let viewModel = DIContainer.shared.resolve(EventsFeedViewModel.self)
    let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
    
    // Симулюємо стан завантаження
    viewModel.isLoadingData = true
    
    return EventsFeedView(viewModel: viewModel)
        .environmentObject(sessionManager)
}
