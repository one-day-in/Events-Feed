// AppCoordinator.swift
import SwiftUI
import Combine

// MARK: - App State
enum AppState {
    case onboarding
    case mainBoard
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published private var currentState: AppState = .onboarding
    private let viewModelFactory: ViewModelFactory
    
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    @ViewBuilder
    func buildCurrentView() -> some View {
        switch currentState {
        case .onboarding:
            onboardingView()
        case .mainBoard:
            mainBoardView()
        }
    }
    
    private func onboardingView() -> some View {
        let viewModel = viewModelFactory.makeOnboardingViewModel()
        
        return OnboardingView(
            onComplete: { [weak self] in
                self?.currentState = .mainBoard
            }
        )
        .environmentObject(viewModel)
    }
    
    private func mainBoardView() -> some View {
        let viewModel = viewModelFactory.makeMainBoardViewModel()
        
        return MainBoardView(
            onLogout: { [weak self] in
                self?.currentState = .onboarding
            }
        )
        .environmentObject(viewModel)
    }
}
