import Foundation

class ConcertService: ConcertServiceProtocol {
    func fetchConcerts() async throws -> (concerts: [Concert], recommended: [Concert]) {
        // Використовуємо мок дані для Preview
        return (MockData.getConcerts(), MockData.getRecommended())
    }
}
