import Foundation

class ConcertMapper {
    
    static func map(_ dto: DTOConcert) -> Concert? {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let startDate = dateFormatter.date(from: dto.startDate),
              let endDate = dateFormatter.date(from: dto.endDate) else {
            return nil
        }
        
        return Concert(
            id: dto.id,
            title: dto.title,
            startDate: startDate,
            endDate: endDate,
            price: Price(amount: dto.minPrice, currency: dto.currency),
            venue: Venue(id: dto.venue.id, name: dto.venue.name, city: dto.venue.city),
            category: Category(id: dto.category.id, name: dto.category.name),
            imageURL: dto.imageUrl.flatMap(URL.init),
            genres: dto.genres ?? [],
            isActive: dto.isActive
        )
    }
    
    static func map(_ dtos: [DTOConcert]) -> [Concert] {
        dtos.compactMap { map($0) }
    }
    
    static func map(_ response: DTOConcertResponse) -> [Concert] {
        map(response.data.items)
    }
}
