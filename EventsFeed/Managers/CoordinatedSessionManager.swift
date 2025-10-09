import Foundation
import Combine

final class CoordinatedSessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var isLoading: Bool = true
    @Published var musicServices: [MusicService] = []
    
    private let userSessionManager: any UserSessionManagerProtocol
    private let musicServiceManager: MusicServiceManager
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userSessionManager: any UserSessionManagerProtocol,
        musicServiceManager: MusicServiceManager = MusicServiceManager()
    ) {
        self.userSessionManager = userSessionManager
        self.musicServiceManager = musicServiceManager
        setupBindings()
    }
    
    // MARK: - Public Methods
    func restoreSession() async {
        await userSessionManager.restoreSession()
    }
    
    func signIn() async {
        await userSessionManager.signIn()
    }
    
    func signOut() {
        userSessionManager.signOut()
        musicServiceManager.disconnectSpotify()
        musicServiceManager.disconnectYouTubeMusic()
    }
    
    // MARK: - Music Service Methods
    func connectSpotify() {
        musicServiceManager.connectSpotify()
    }
    
    func disconnectSpotify() {
        musicServiceManager.disconnectSpotify()
    }
    
    var isSpotifyConnected: Bool {
        return musicServiceManager.isSpotifyConnected
    }
    
    func connectYouTubeMusic() {
        musicServiceManager.connectYouTubeMusic()
    }
    
    func disconnectYouTubeMusic() {
        musicServiceManager.disconnectYouTubeMusic()
    }
    
    var isYouTubeMusicConnected: Bool {
        return musicServiceManager.isYouTubeMusicConnected
    }
        
    // MARK: - Private Methods
    private func setupBindings() {
        setupUserSessionBindings()
        setupMusicServiceBindings()
        setupSpecificPropertyListeners()
    }
    
    private func setupUserSessionBindings() {
        let timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateUserSessionState()
            }
        
        timer.store(in: &cancellables)
    }
    
    private func setupMusicServiceBindings() {
        // Підписуємось на зміни в musicServiceManager
        musicServiceManager.$musicServices
            .receive(on: RunLoop.main)
            .sink { [weak self] services in
                self?.musicServices = services
            }
            .store(in: &cancellables)
    }
    
    private func setupSpecificPropertyListeners() {
        // Додаткові слухачі для миттєвих оновлень
        NotificationCenter.default.publisher(for: .spotifyAuthSuccess)
            .sink { [weak self] _ in
                self?.musicServiceManager.updateMusicServices()
            }
            .store(in: &cancellables)
            
        NotificationCenter.default.publisher(for: .spotifyDisconnected)
            .sink { [weak self] _ in
                self?.musicServiceManager.updateMusicServices()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .youtubeMusicAuthSuccess)
            .sink { [weak self] _ in
                self?.musicServiceManager.updateMusicServices()
            }
            .store(in: &cancellables)
                
        NotificationCenter.default.publisher(for: .youtubeMusicDisconnected)
            .sink { [weak self] _ in
                self?.musicServiceManager.updateMusicServices()
            }
            .store(in: &cancellables)
    }
    
    private func updateUserSessionState() {
        let newIsLoggedIn = userSessionManager.isLoggedIn
        let newCurrentUser = userSessionManager.currentUser
        let newIsLoading = userSessionManager.isLoading
        
        if isLoggedIn != newIsLoggedIn {
            isLoggedIn = newIsLoggedIn
        }
        if currentUser != newCurrentUser {
            currentUser = newCurrentUser
        }
        if isLoading != newIsLoading {
            isLoading = newIsLoading
        }
    }
}
