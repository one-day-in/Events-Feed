import Foundation
import Combine

@MainActor
final class AppStateManager: ObservableObject {
    // MARK: - Published State for UI
    @Published private(set) var appPhase: AppPhase = .splash
    @Published private(set) var appState: AppState = .unauthenticated
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var currentUser: User? = nil
    @Published private(set) var connectedServices: [MusicServiceType] = []
    
    // MARK: - Dependencies
    private let userManager: UserManager
    private let musicServiceManager: MusicServiceManager
    private let errorService: ErrorService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - App Enums
    enum AppPhase { case splash, ready }
    enum AppState { case unauthenticated, authenticated }
    
    // MARK: - Init
    init(userManager: UserManager, musicServiceManager: MusicServiceManager, errorService: ErrorService) {
        self.userManager = userManager
        self.musicServiceManager = musicServiceManager
        self.errorService = errorService
        setupBindings()
        setupErrorMonitoring()
    }

    
    // MARK: - Lifecycle
    func startApp() async {
        isLoading = true
        await userManager.restoreSession()
        completeSplashPhase()
        isLoading = false
    }

    
    func completeSplashPhase() {
        appPhase = .ready
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        // Авторизація
        userManager.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.appState = isLoggedIn ? .authenticated : .unauthenticated
            }
            .store(in: &cancellables)
        
        userManager.$currentUser
            .assign(to: &$currentUser)
        
        userManager.$isLoading
            .assign(to: &$isLoading)

        // Вихід користувача → відключення музичних сервісів
        userManager.signOutCompleted
            .sink { [weak self] in
                guard let self = self else { return }
                print("👋 User logged out — disconnecting all music services")
                MusicServiceType.allCases.forEach { self.musicServiceManager.disconnectService($0) }
            }
            .store(in: &cancellables)
        
        // Музичні сервіси
        musicServiceManager.$connectedServices
            .assign(to: &$connectedServices)
    }
    
    private func handleAppError(_ error: AppError) {
        switch error {
        case .auth(let description):
            Task { await userManager.signOut() }
            NotificationService.shared.post(name: .userDidSignOut, object: nil)
            print("🔒 Auth error: \(description)")
        case .network(let description):
            print("🌐 Network issue: \(description)")
        default:
            break
        }
    }

    
    private func setupErrorMonitoring() {
        errorService.$currentError
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] appError in
                self?.handleAppError(appError)
            }
            .store(in: &cancellables)
    }

}
