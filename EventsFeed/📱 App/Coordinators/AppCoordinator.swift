import SwiftUI

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
        RootView(content: AnyView(currentView))
    }
    
    @ViewBuilder
    private var currentView: some View {
        switch currentState {
        case .onboarding:
            makeOnboardingView()
            
        case .mainBoard:
            makeMainBoardView()
        }
    }
    
    private func makeOnboardingView() -> some View {
        OnboardingView(
            onComplete: { [weak self] in
                self?.currentState = .mainBoard
            }
        )
        .environmentObject(viewModelFactory.makeOnboardingViewModel())
    }
    
    private func makeMainBoardView() -> some View {
        let tabCoordinator = MainBoardCoordinator(
            viewModelFactory: viewModelFactory,
            onLogout: { [weak self] in
                // Цей closure викликається коли користувач робить логаут в ProfileView
                self?.handleLogout()
            }
        )
        
        return MainBoardView(tabCoordinator: tabCoordinator)
    }
    
    private func handleLogout() {
        // Тут можна додати додаткову логіку перед переходом на onboarding
        // Наприклад, очистка даних, відключення сервісів тощо
        
        // Переходимо на onboarding
        currentState = .onboarding
    }
}
