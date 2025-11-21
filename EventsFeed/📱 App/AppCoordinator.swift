import SwiftUI

enum AppState {
    case onboarding
    case mainTab
}

@MainActor
final class AppCoordinator: ObservableObject {

    @Published private var state: AppState = .onboarding
    private let builder: ModuleBuilder

    init(builder: ModuleBuilder) {
        self.builder = builder
    }

    @ViewBuilder
    func rootView() -> some View {
        switch state {

        case .onboarding:
            builder.makeOnboardingModule {
                self.state = .mainTab
            }

        case .mainTab:
            builder.makeMainTabModule {
                self.handleLogout()
            }
        }
    }

    private func handleLogout() {
        state = .onboarding
    }
}
