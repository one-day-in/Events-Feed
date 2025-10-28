import Foundation

// MARK: - Єдиний протокол для всіх сервісів
protocol MusicServiceProtocol: ObservableObject {
    var isConnected: Bool { get }
    var serviceType: MusicServiceType { get }

    func authenticate() async throws
    func disconnect()
    func restoreSession() async throws
    func handleAuthCallback(url: URL) async throws -> Bool
}

