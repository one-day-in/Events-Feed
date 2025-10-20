import Foundation
import Swinject

final class ViewModelsAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - EventsFeed ViewModels
//        _ = container.registerMainActor(EventsFeedContentViewModel.self) { resolver in
//            EventsFeedContentViewModel(
//                concertService: resolver.resolve(ConcertServiceProtocol.self)!,
//                errorService: resolver.resolve(ErrorService.self)!
//            )
//        }
//        
//        _ = container.registerMainActor(EventsFeedBehaviorViewModel.self) { resolver in
//            EventsFeedBehaviorViewModel(errorService: resolver.resolve(ErrorService.self)!)
//        }
//        
//        _ = container.registerMainActor(EventsFeedManager.self) { resolver in
//            EventsFeedManager(
//                content: resolver.resolve(EventsFeedContentViewModel.self)!,
//                behavior: resolver.resolve(EventsFeedBehaviorViewModel.self)!,
//                errorService: resolver.resolve(ErrorService.self)!
//            )
//        }
//        
//        // MARK: - Profile ViewModel
//        _ = container.registerMainActor(ProfileViewModel.self) { resolver in
//            ProfileViewModel(
//                sessionManager: resolver.resolve(SessionManager.self)!
//            )
//        }
        
//        // MARK: - MainTab ViewModel
//        _ = container.registerMainActor(MainTabViewModel.self) { resolver in
//            MainTabViewModel(
//                sessionManager: resolver.resolve(SessionManager.self)!,
//                eventsFeedManager: resolver.resolve(EventsFeedManager.self)!,
//                errorService: resolver.resolve(ErrorService.self)!
//            )
//        }
        
//        // MARK: - Auth ViewModel
//        _ = container.registerMainActor(AuthViewModel.self) { resolver in
//            AuthViewModel(
//                sessionManager: resolver.resolve(SessionManager.self)!,
//                errorService: resolver.resolve(ErrorService.self)!
//            )
//        }
    }
}
