import Foundation

@MainActor
final class ViewModelFactory {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Onboarding
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(
            authManager: container.resolve(AuthManager.self),
            errorHandler: container.resolve(ErrorHandler.self),
            loadingService: container.resolve(LoadingService.self)
        )
    }
    
    // MARK: - Tab Views
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            concertService: container.resolve(ConcertService.self),
            errorHandler: container.resolve(ErrorHandler.self)
        )
    }
    
//    func makeExploreViewModel() -> ExploreViewModel {
//        ExploreViewModel(
//            // ... dependencies
//        )
//    }
    
    func makeProfileViewModel(onLogout: @escaping () -> Void) -> ProfileViewModel {
            ProfileViewModel(
                authManager: container.resolve(AuthManager.self),
                musicServiceManager: container.resolve(MusicServiceManager.self),
                errorHandler: container.resolve(ErrorHandler.self),
                loadingService: container.resolve(LoadingService.self),
                onLogout: onLogout
            )
        }
}


