//// Features/MainTab/ViewModels/MainTabViewModel.swift
//import SwiftUI
//
//@MainActor
//final class MainTabViewModel: BaseViewModel {
//    
//    // MARK: - Published Properties
//    @Published var selectedTab: Int = 0
//    @Published var isUserLoggedIn: Bool = false
//    @Published var user: User?
//    
//    // MARK: - Dependencies
//    private let sessionManager: SessionManager
//    private let eventsFeedManager: EventsFeedManager
//    
//    // MARK: - Initialization
//    init(
//        sessionManager: SessionManager,
//        eventsFeedManager: EventsFeedManager,
//        errorService: ErrorService
//    ) {
//        self.sessionManager = sessionManager
//        self.eventsFeedManager = eventsFeedManager
//        super.init(errorService: errorService)
//        setupBindings()
//    }
//    
//    // MARK: - Public Methods
//    func signOut() async {
//        await executeTask {
//            self.sessionManager.signOut()
//        }
//    }
//    
//    // MARK: - Music Service Methods
//    func connectService(_ type: MusicServiceType) {
//        sessionManager.connectService(type)
//    }
//    
//    func disconnectService(_ type: MusicServiceType) {
//        sessionManager.disconnectService(type)
//    }
//    
//    func isServiceConnected(_ type: MusicServiceType) -> Bool {
//        sessionManager.isServiceConnected(type)
//    }
//    
//    // MARK: - Private Methods
//    private func setupBindings() {
//        sessionManager.$isLoggedIn
//            .assign(to: &$isUserLoggedIn)
//        
//        sessionManager.$currentUser
//            .assign(to: &$user)
//    }
//}
