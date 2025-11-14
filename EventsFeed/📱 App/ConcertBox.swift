import SwiftUI

@main
struct ConcertBox: App {
    @StateObject private var appCoordinator: AppCoordinator
    private let container: DIContainer
    
    init() {
        self.container = DIContainer()
        let viewModelFactory = ViewModelFactory(container: container)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(
            viewModelFactory: viewModelFactory
        ))
        
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.buildCurrentView()
                .environmentObject(container.resolve(LoadingService.self))
                .environmentObject(container.resolve(ErrorHandler.self))
        }
    }
}
