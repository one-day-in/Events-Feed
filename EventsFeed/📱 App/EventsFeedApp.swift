import SwiftUI

@main
struct EventsFeed: App {
    @StateObject private var appCoordinator: AppCoordinator
    private let container: DIContainer
    
    init() {
        self.container = DIContainer()
        let viewModelFactory = ViewModelFactory(container: container)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(viewModelFactory: viewModelFactory))
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.buildCurrentView()
                .withGlobalHandlers(
                    loadingService: container.resolve(LoadingService.self),
                    errorService: container.resolve(UIErrorService.self)
                )
        }
    }
}
