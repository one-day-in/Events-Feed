import Foundation

struct SpotifyTrack: Codable, Identifiable {
    let id: String
    let name: String
    let artist: String
    let album: String?
    let duration: TimeInterval
    let previewUrl: String?
}
