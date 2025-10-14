import Foundation

struct YouTubeMusicHistoryItem: Codable, Identifiable {
    let id: String
    let title: String
    let artist: String
    let playedAt: Date
    let duration: TimeInterval
}

struct YouTubeMusicTrack: Codable, Identifiable {
    let id: String
    let title: String
    let artist: String
    let album: String?
    let duration: TimeInterval
    let thumbnails: [YouTubeThumbnail]
}

struct YouTubeThumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
}
