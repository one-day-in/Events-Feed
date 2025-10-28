import SwiftUI

@MainActor
final class MainBoardViewModel: ObservableObject {
    private let authManager: AuthManager
    private let musicServiceManager: MusicServiceManager
    private let errorService: UIErrorService
    private let loadingService: LoadingService
    
    init(
        authManager: AuthManager,
        musicServiceManager: MusicServiceManager,
        errorService: UIErrorService,
        loadingService: LoadingService
    ) {
        self.authManager = authManager
        self.musicServiceManager = musicServiceManager
        self.errorService = errorService
        self.loadingService = loadingService
    }
    
    // MARK: - Public API
    var connectedServices: [MusicServiceType] {
        musicServiceManager.connectedServices
    }
    
    func connectMusicService(_ service: MusicServiceType) async {
        loadingService.setLoading(true, context: "connect_\(service)")
        defer { loadingService.setLoading(false, context: "connect_\(service)") }
        
        do {
            try await musicServiceManager.connectService(service)
            await fetchAndSendUserMusicData(service)
        } catch {
            errorService.report(error, context: "Connect \(service)")
        }
    }
    
    func disconnectMusicService(_ service: MusicServiceType) {
        loadingService.setLoading(true, context: "disconnect_\(service)")
        defer { loadingService.setLoading(false, context: "disconnect_\(service)") }
        musicServiceManager.disconnectService(service)
    }
    
    func signOut() {
        loadingService.setLoading(true, context: "sign_out")
        defer { loadingService.setLoading(false, context: "sign_out") }
        
        do {
            try authManager.signOut()
        } catch {
            errorService.report(error, context: "Sign Out")
        }
    }
    
    // MARK: - Private
    private func fetchAndSendUserMusicData(_ service: MusicServiceType) async {
        // Тут буде логіка отримання даних про музику
        // та відправки на бекенд
    }
}
