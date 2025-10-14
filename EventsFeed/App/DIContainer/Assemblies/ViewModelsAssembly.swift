import Foundation
import Swinject

final class ViewModelsAssembly: Assembly {
    nonisolated func assemble(container: Container) {
        // MARK: - EventsFeed
        container.registerMainActor(EventsFeedContentViewModel.self) { resolver in
            let concertService = resolver.resolve(ConcertServiceProtocol.self)!
            let errorService = resolver.resolve(ErrorService.self)!
            return EventsFeedContentViewModel(
                concertService: concertService,
                errorService: errorService
            )
        }.inObjectScope(.container)
        
        container.registerMainActor(EventsFeedBehaviorViewModel.self) { _ in
            return EventsFeedBehaviorViewModel()
        }.inObjectScope(.container)
        
        container.registerMainActor(EventsFeedManager.self) { resolver in
            let content = resolver.resolve(EventsFeedContentViewModel.self)!
            let behavior = resolver.resolve(EventsFeedBehaviorViewModel.self)!
            return EventsFeedManager(content: content, behavior: behavior)
        }.inObjectScope(.container)
    }
}
