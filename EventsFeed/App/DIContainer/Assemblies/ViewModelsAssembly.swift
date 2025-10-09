import Foundation
import Swinject

final class ViewModelsAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - ViewModels
        
        // EventsFeedViewModel
        container.register(EventsFeedViewModel.self) { resolver in
            let concertService = resolver.resolve(ConcertServiceProtocol.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            return EventsFeedViewModel(
                concertService: concertService,
                errorService: errorService
            )
        }.inObjectScope(.container)
        
        // RootViewModel
        container.register(RootViewModel.self) { resolver in
            let sessionManager = resolver.resolve(CoordinatedSessionManager.self)!
            return RootViewModel(sessionManager: sessionManager)
        }.inObjectScope(.container)
        
        // ProfileViewModel
        container.register(ProfileViewModel.self) { resolver in
            let sessionManager = resolver.resolve(CoordinatedSessionManager.self)!
            return ProfileViewModel(sessionManager: sessionManager)
        }.inObjectScope(.container)
               
    }
}
