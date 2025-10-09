import Foundation

struct Concert: Identifiable, Codable {
    let id: UUID
    let title: String
    let artist: String?
    let date: Date
    let location: String
    let city: String
    let price: Double?
    let imageName: String
    let isSaved: Bool
    let artistID: String
    let isAnnouncement: Bool
    let genre: String?
}
