import Foundation

struct Concert: Identifiable, Equatable {
    let id: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let price: Price
    let venue: Venue
    let category: Category
    let imageURL: URL?
    let genres: [String]
    let isActive: Bool
}

struct Price: Equatable {
    let amount: Int
    let currency: String
    
    var formatted: String {
        "\(amount) \(currency)"
    }
}

struct Venue: Identifiable, Equatable {
    let id: Int
    let name: String
    let city: String
    
    var location: String {
        "\(name), \(city)"
    }
}

struct Category: Identifiable, Equatable {
    let id: Int
    let name: String
}
