import Foundation

struct MusicServiceToken: Codable {
    let accessToken: String
    let expiry: Date?

    var isExpired: Bool {
        guard let expiry else { return false }
        return Date() >= expiry
    }
}
