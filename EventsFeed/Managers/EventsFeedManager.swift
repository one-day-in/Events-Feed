import Foundation

@MainActor
class EventsFeedManager: ObservableObject {
    let content: EventsFeedContentViewModel
    let behavior: EventsFeedBehaviorViewModel
    
    init(content: EventsFeedContentViewModel, behavior: EventsFeedBehaviorViewModel) {
        self.content = content
        self.behavior = behavior
    }
    
    func onAppear() {
        behavior.resetScrollState()
        loadContentIfNeeded()
    }
    
    private func loadContentIfNeeded() {
        if content.concerts.isEmpty && !content.isLoadingData {
            Task {
                await content.loadConcerts()
            }
        }
    }
}
