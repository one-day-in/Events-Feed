import Foundation

protocol ConcertServiceProtocol {
    func fetchConcerts() async throws -> (concerts: [Concert], recommended: [Concert])
}

