import SwiftUI

@MainActor
final class ModuleBuilder {

    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - Onboarding Module
    func makeOnboardingModule(onFinish: @escaping () -> Void) -> OnboardingView {
        let viewModel = OnboardingViewModel(
            authManager: container.resolve(AuthManager.self),
            errorHandler: container.resolve(ErrorHandler.self),
            loadingService: container.resolve(LoadingService.self)
        )

        return OnboardingView(viewModel: viewModel, onComplete: onFinish)
    }

    // MARK: - Main Tab Module
    func makeMainTabModule(onLogout: @escaping () -> Void) -> MainTabView {
        let home = makeHomeModule()
        let explore = makeExploreModule()
        let profile = makeProfileModule(onLogout: onLogout)

        return MainTabView(
            home: home,
            explore: explore,
            profile: profile
        )
    }

    // MARK: - Child Feature Modules
    private func makeHomeModule() -> HomeView {
        let viewModel = HomeViewModel(
            concertService: container.resolve(ConcertService.self),
            errorHandler: container.resolve(ErrorHandler.self)
        )
        return HomeView(viewModel: viewModel)
    }

    private func makeExploreModule() -> ExploreView {
//        let viewModel = ExploreViewModel()
        return ExploreView()
    }

    private func makeProfileModule(onLogout: @escaping () -> Void) -> ProfileView {
        let viewModel = ProfileViewModel(
            authManager: container.resolve(AuthManager.self),
            musicServiceManager: container.resolve(MusicServiceManager.self),
            errorHandler: container.resolve(ErrorHandler.self),
            loadingService: container.resolve(LoadingService.self),
            onLogout: onLogout
        )
        return ProfileView(viewModel: viewModel)
    }
}
