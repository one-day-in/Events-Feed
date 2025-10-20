// Features/EventsFeed/ViewModels/EventsFeedContentViewModel.swift
import Foundation
import SwiftUI

@MainActor
final class EventsFeedContentViewModel: BaseViewModel {
    @Published var concerts: [Concert] = []
    @Published var recommendedConcerts: [Concert] = []
    @Published var selectedSection: ConcertSection = .upcoming
    
    // MARK: - Computed Properties
    var hasData: Bool { !concerts.isEmpty }
    
//    var filteredConcerts: [Concert] {
//        var filtered = concerts
//        
//        let now = Date()
//        switch selectedSection {
//        case .upcoming:
//            filtered = filtered.filter { $0.date > now && $0.date <= Calendar.current.date(byAdding: .month, value: 2, to: now)! }
//        case .today:
//            filtered = filtered.filter { Calendar.current.isDateInToday($0.date) }
//        case .past:
//            filtered = filtered.filter { $0.date < now }
//        case .announs:
//            filtered = filtered.filter { $0.isAnnouncement }
//        }
//        
//        return filtered.sorted { $0.date < $1.date }
//    }
//    
//    // MARK: - Dependencies
//    private let concertService: ConcertServiceProtocol
//    
//    // MARK: - Initialization
//    init(
//        concertService: ConcertServiceProtocol,
//        errorService: ErrorService
//    ) {
//        self.concertService = concertService
//        super.init(errorService: errorService)
//    }
//    
//    // MARK: - Public Methods
//    func loadData() async {
//        await executeTask {
//            try await self.loadConcerts()
//        }
//    }
//    
//    func refreshData() async {
//        await executeTask {
//            try await self.loadConcerts()
//        }
//    }
//    
//    func selectSection(_ section: ConcertSection) {
//        selectedSection = section
//    }
//    
//    // MARK: - Private Methods
//    private func loadConcerts() async throws {
//        // Симуляція завантаження (можна видалити)
//        try await Task.sleep(nanoseconds: 1_500_000_000)
//        
//        let data = try await concertService.fetchConcerts()
//        self.concerts = data.concerts
//        self.recommendedConcerts = data.recommended
//        errorService.clearCurrentError()
//    }
//    
//    private func loadMockData() {
//        self.concerts = MockData.getConcerts()
//        self.recommendedConcerts = MockData.getRecommended()
//    }
}
