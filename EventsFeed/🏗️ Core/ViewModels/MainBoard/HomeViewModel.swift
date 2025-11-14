import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var concerts: [Concert] = []
    @Published var isLoadingMore = false
    
    private let concertService: ConcertService
    private let errorHandler: ErrorHandler
    private var currentPage = 1
    private var canLoadMore = true
    private var hasLoadedInitialData = false
    
    init(
        concertService: ConcertService,
        errorHandler: ErrorHandler
    ) {
        self.concertService = concertService
        self.errorHandler = errorHandler
    }
    
    func loadConcerts() async {
        guard !hasLoadedInitialData else { return }
        
        isLoadingMore = true
        defer {
            isLoadingMore = false
            hasLoadedInitialData = true
        }
        
        do {
            let newConcerts = try await concertService.fetchConcerts(offset: currentPage)
            concerts.append(contentsOf: newConcerts)
            canLoadMore = !newConcerts.isEmpty
            currentPage += 1
        } catch {
            errorHandler.handle(error, context: "Load Concerts")
        }
    }
    
    func loadMoreConcertsIfNeeded() async {
        guard !isLoadingMore && canLoadMore else { return }
        
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            let newConcerts = try await concertService.fetchConcerts(offset: currentPage)
            concerts.append(contentsOf: newConcerts)
            canLoadMore = !newConcerts.isEmpty
            currentPage += 1
        } catch {
            errorHandler.handle(error, context: "Load More Concerts")
        }
    }
}
