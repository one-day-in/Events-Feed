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

#Preview("Перше завантаження") {
    let container = DIContainer()
    let viewModelFactory = ViewModelFactory(container: container)
    
    let homeViewModel = viewModelFactory.makeHomeViewModel()
    homeViewModel.isLoadingMore = true // ← Шимери для першого завантаження
    
    return HomeView(viewModel: homeViewModel)
}

//#Preview("З даними") {
//    let container = DIContainer()
//    let viewModelFactory = ViewModelFactory(container: container)
//    
//    let homeViewModel = viewModelFactory.makeHomeViewModel()
//    
//    // Додаємо тестові дані
//    homeViewModel.concerts = .getConcerts()
//    
//    return HomeView(viewModel: homeViewModel)
//}
//
//#Preview("Пагінація") {
//    let container = DIContainer()
//    let viewModelFactory = ViewModelFactory(container: container)
//    
//    let homeViewModel = viewModelFactory.makeHomeViewModel()
//    
//    // Додаємо дані + симулюємо пагінацію
//    homeViewModel.concerts = MockData.getConcerts()
//    homeViewModel.isLoadingMore = true
//    
//    return HomeView(viewModel: homeViewModel)
//}
//
//#Preview("З даними") {
//    let container = DIContainer()
//    let viewModelFactory = ViewModelFactory(container: container)
//    
//    let homeViewModel = viewModelFactory.makeHomeViewModel()
//    
//    return HomeView(viewModel: homeViewModel)
//}
//
//#Preview("Завантаження") {
//    let container = DIContainer()
//    let viewModelFactory = ViewModelFactory(container: container)
//    
//    let homeViewModel = viewModelFactory.makeHomeViewModel()
//    
//    // Симулюємо стан завантаження
//    homeViewModel.isLoadingMore = true
//    
//    return HomeView(viewModel: homeViewModel)
//}
//
//#Preview("Пустий стан") {
//    let container = DIContainer()
//    let viewModelFactory = ViewModelFactory(container: container)
//    
//    let homeViewModel = viewModelFactory.makeHomeViewModel()
//    
//    // Залишаємо пустий масив концертів
//    // homeViewModel.concerts = []
//    
//    return HomeView(viewModel: homeViewModel)
//}
