// MainTabCoordinator.swift
import SwiftUI

@MainActor
final class MainBoardCoordinator: ObservableObject {
    private let viewModelFactory: ViewModelFactory
    private let onLogout: () -> Void
    
    init(viewModelFactory: ViewModelFactory, onLogout: @escaping () -> Void) {
        self.viewModelFactory = viewModelFactory
        self.onLogout = onLogout
    }
    
    // MARK: - Tab Views
    func makeHomeView() -> some View {
        let viewModel = viewModelFactory.makeHomeViewModel()
        return HomeView(viewModel: viewModel)
    }
    
    func makeExploreView() -> some View {
        return Text("")
//        let viewModel = viewModelFactory.makeExploreViewModel()
//        return ExploreView(viewModel: viewModel)
    }
    
    func makeProfileView() -> some View {
        // Передаємо onLogout в ProfileViewModel
        let viewModel = viewModelFactory.makeProfileViewModel(onLogout: onLogout)
        return ProfileView(viewModel: viewModel)
    }
}
