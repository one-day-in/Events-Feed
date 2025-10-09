import Foundation
import SwiftUI

class EventsFeedViewModel: ObservableObject {
    @Published var concerts: [Concert] = []
    @Published var recommendedConcerts: [Concert] = []
    @Published var selectedSection: ConcertSection = .upcoming
    @Published var isLoadingData: Bool = false
    
    private let concertService: ConcertServiceProtocol
    private let errorService: ErrorService
    
    init(concertService: ConcertServiceProtocol, errorService: ErrorService) {
        self.concertService = concertService
        self.errorService = errorService
    }
    
    var filteredConcerts: [Concert] {
        var filtered = concerts
        
        let now = Date()
        switch selectedSection {
        case .upcoming:
            filtered = filtered.filter { $0.date > now && $0.date <= Calendar.current.date(byAdding: .month, value: 2, to: now)! }
        case .today:
            filtered = filtered.filter { Calendar.current.isDateInToday($0.date) }
        case .past:
            filtered = filtered.filter { $0.date < now }
        case .announs:
            filtered = filtered.filter { $0.isAnnouncement }
        }
        
        return filtered.sorted { $0.date < $1.date }
    }
    
    @MainActor
    func loadConcerts() async {
        isLoadingData = true
        defer { isLoadingData = false }
        
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            let data = try await concertService.fetchConcerts()
            self.concerts = data.concerts
            self.recommendedConcerts = data.recommended
            errorService.clearCurrentError()
        } catch {
            errorService.report(error, context: "Loading concerts")
            self.loadMockData()
        }
    }
    
    private func loadMockData() {
        self.concerts = MockData.getConcerts()
        self.recommendedConcerts = MockData.getRecommended()
    }
}
