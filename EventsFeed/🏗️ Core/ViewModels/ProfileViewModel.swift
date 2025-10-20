//// Features/Profile/ViewModels/ProfileViewModel.swift
//import SwiftUI
//
//@MainActor
//final class ProfileViewModel: BaseViewModel {
//    
//    // MARK: - Published Properties
//    @Published var user: User?
//    @Published var isLoggedIn: Bool = false
//    @Published var connectedServices: [MusicServiceType] = []
//    
//    // MARK: - Computed Properties
//    var appVersion: String {
//        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
//    }
//    
//    // MARK: - Dependencies
//    private let sessionManager: SessionManager
//    
//    // MARK: - Initialization
//    init(sessionManager: SessionManager) {
//        self.sessionManager = sessionManager
//        super.init()
//        setupBindings()
//    }
//    
//    // MARK: - Authentication Methods
//    func signOut() async {
//        await executeTask {
//            self.sessionManager.signOut()
//        }
//    }
//    
//    // MARK: - Music Service Methods
//    func connectService(_ type: MusicServiceType) async {
//        sessionManager.connectService(type)
//    }
//    
//    func disconnectService(_ type: MusicServiceType) async {
//        sessionManager.disconnectService(type)
//    }
//    
//    func isServiceConnected(_ type: MusicServiceType) -> Bool {
//        sessionManager.isServiceConnected(type)
//    }
//    
//    // MARK: - Convenience Methods
//    func connectSpotify() {
//        sessionManager.connectSpotify()
//    }
//    
//    func disconnectSpotify() {
//        sessionManager.disconnectSpotify()
//    }
//    
//    func connectYouTubeMusic() {
//        sessionManager.connectYouTubeMusic()
//    }
//    
//    func disconnectYouTubeMusic() {
//        sessionManager.disconnectYouTubeMusic()
//    }
//    
//    func connectAppleMusic() {
//        sessionManager.connectAppleMusic()
//    }
//    
//    func disconnectAppleMusic() {
//        sessionManager.disconnectAppleMusic()
//    }
//    
//    // MARK: - Private Methods
//    private func setupBindings() {
//        sessionManager.$isLoggedIn
//            .assign(to: &$isLoggedIn)
//        
//        sessionManager.$currentUser
//            .assign(to: &$user)
//        
//        sessionManager.$musicServices
//            .map { services in
//                services.filter { $0.isConnected }.map { $0.type }
//            }
//            .assign(to: &$connectedServices)
//    }
//}
