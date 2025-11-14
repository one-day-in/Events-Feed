import Foundation

struct DTOConcertResponse: Decodable {
    let success: Bool
    let data: DTOConcertData
}

struct DTOConcertData: Decodable {
    let items: [DTOConcert]
    let total: Int
    let offset: Int
    let limit: Int
}

struct DTOConcert: Decodable {
    let id: Int
    let slug: String
    let type: String
    let title: String
    let startDate: String
    let endDate: String
    let minPrice: Int
    let currency: String
    let imageUrl: String?
    let venue: DTOVenue
    let category: DTOCategory
    let genres: [String]?
    let isActive: Bool
    
    // Якщо API повертає інші назви полів - використовуємо CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, slug, type, title
        case startDate = "start_date"
        case endDate = "end_date"
        case minPrice = "min_price"
        case currency, imageUrl, venue, category, genres
        case isActive = "is_active"
    }
}

struct DTOVenue: Decodable {
    let id: Int
    let name: String
    let city: String
}

struct DTOCategory: Decodable {
    let id: Int
    let name: String
}
