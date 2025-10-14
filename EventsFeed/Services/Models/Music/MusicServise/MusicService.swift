import Foundation

struct MusicService: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let isConnected: Bool
    let iconName: String
    let serviceType: MusicServiceType
    
    static func == (lhs: MusicService, rhs: MusicService) -> Bool {
        return lhs.id == rhs.id && lhs.isConnected == rhs.isConnected
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isConnected)
    }
}
