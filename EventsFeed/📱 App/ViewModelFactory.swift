import Foundation

@MainActor
final class ViewModelFactory {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(
            authManager: container.resolve(AuthManager.self),
            errorService: container.resolve(UIErrorService.self),
            loadingService: container.resolve(LoadingService.self)
        )
    }
    
    func makeMainBoardViewModel() -> MainBoardViewModel {
        MainBoardViewModel(
            authManager: container.resolve(AuthManager.self),
            musicServiceManager: container.resolve(MusicServiceManager.self),
            errorService: container.resolve(UIErrorService.self),
            loadingService: container.resolve(LoadingService.self)
        )
    }
}
