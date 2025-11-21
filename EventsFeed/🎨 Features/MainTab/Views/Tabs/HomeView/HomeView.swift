import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var isHeaderHidden = false
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    Color.clear
                        .frame(height: 100)
                    
                    ForEach(viewModel.concerts) { concert in
                        ConcertCardView(concert: concert)
                    }
                    
                    if viewModel.isLoadingMore {
                        ForEach(0..<3, id: \.self) { _ in
                            ConcertCardPlaceholderView()
                        }
                    }
                }
                .onUserScroll { direction in
                    handleUserScroll(direction)
                }
                .onBottomScroll(threshold: 200) {
                    Task {
                        await viewModel.loadMoreConcertsIfNeeded()
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            
            HeaderView()
                .offset(y: isHeaderHidden ? -100 : 0)
                .animation(.spring(response: 0.3), value: isHeaderHidden)
        }
        .onAppear {
            if viewModel.concerts.isEmpty {
                Task {
                    await viewModel.loadConcerts()
                }
            }
        }
    }
    
    private func handleUserScroll(_ direction: ScrollDirection) {
        switch direction {
        case .up:
            // Завжди ховаємо при скролі вгору
            withAnimation(.spring(response: 0.3)) {
                isHeaderHidden = true
            }
        case .down:
            // Завжди показуємо при скролі вниз
            withAnimation(.spring(response: 0.3)) {
                isHeaderHidden = false
            }
        }
    }
}
