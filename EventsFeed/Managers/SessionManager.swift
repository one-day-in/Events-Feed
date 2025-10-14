// SessionManager.swift
import SwiftUI
import Combine

@MainActor
final class SessionManager: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var currentUser: User? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var musicServices: [MusicService] = []
    @Published private(set) var currentAuthProvider: AuthProvider = .google
    
    // MARK: - Computed Properties
    var isSpotifyConnected: Bool { isServiceConnected(.spotify) }
    var isYouTubeMusicConnected: Bool { isServiceConnected(.youtubeMusic) }
    var isAppleMusicConnected: Bool { isServiceConnected(.appleMusic) }
    
    // MARK: - Private Dependencies
    private let authManager: AuthManager
    private let musicServiceManager: MusicServiceManager
    private let errorService: ErrorService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        authManager: AuthManager,
        musicServiceManager: MusicServiceManager,
        errorService: ErrorService
    ) {
        self.authManager = authManager
        self.musicServiceManager = musicServiceManager
        self.errorService = errorService
        setupBindings()
        Task { await restoreSession() }
    }
    
    // MARK: - Authentication Methods
    func signIn(with provider: AuthProvider) async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let options = AuthSignInOptions(
                presentationContext: UIApplication.shared.rootViewController,
                scopes: nil,
                parameters: nil
            )
            let user = try await authManager.signIn(with: provider, options: options)
            print("SessionManager: User signed in. User ID: \(user.id)")
            
        } catch {
            print("SessionManager: Sign in failed: \(error)")
            errorService.report(error)
        }
        
        isLoading = false
    }
    
    func signOut() {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            try authManager.signOut()
            // Відключаємо всі музичні сервіси при виході
            MusicServiceType.allCases.forEach { type in
                musicServiceManager.disconnectService(type)
            }
            print("SessionManager: User signed out.")
            
        } catch {
            print("SessionManager: Sign out failed: \(error)")
            errorService.report(error)
        }
        
        isLoading = false
    }
    
    func restoreSession() async {
        await authManager.restoreSession()
    }
    
    func handleAuthURL(_ url: URL) -> Bool {
        return authManager.handle(url)
    }
    
    // MARK: - Music Service Methods
    func connectService(_ type: MusicServiceType) {
        musicServiceManager.connectService(type)
    }
    
    func disconnectService(_ type: MusicServiceType) {
        musicServiceManager.disconnectService(type)
    }
    
    func isServiceConnected(_ type: MusicServiceType) -> Bool {
        musicServiceManager.isServiceConnected(type)
    }
    
    // MARK: - Convenience Methods
    func connectSpotify() { connectService(.spotify) }
    func disconnectSpotify() { disconnectService(.spotify) }
    func connectYouTubeMusic() { connectService(.youtubeMusic) }
    func disconnectYouTubeMusic() { disconnectService(.youtubeMusic) }
    func connectAppleMusic() { connectService(.appleMusic) }
    func disconnectAppleMusic() { disconnectService(.appleMusic) }
    
    // MARK: - Private Methods
    private func setupBindings() {
        setupAuthBindings()
        setupMusicServiceBindings()
    }
    
    private func setupAuthBindings() {
        authManager.$isUserLoggedIn
            .assign(to: &$isLoggedIn)
        
        authManager.$currentUser
            .assign(to: &$currentUser)
        
        authManager.$isLoading
            .assign(to: &$isLoading)
        
        authManager.$currentProvider
            .assign(to: &$currentAuthProvider)
    }
    
    private func setupMusicServiceBindings() {
        musicServiceManager.musicServicesPublisher
            .assign(to: &$musicServices)
    }
}
