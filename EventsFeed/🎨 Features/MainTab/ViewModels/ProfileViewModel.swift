import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var user: User?
    @Published var musicServiceStates: [MusicServiceType: MusicServiceManager.ConnectionState] = [:]
    
    // MARK: - Dependencies
    private let authManager: AuthManager
    private let musicServiceManager: MusicServiceManager
    private let errorHandler: ErrorHandler
    private let loadingService: LoadingService
    private let onLogout: () -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version).\(build)"
    }
    
    var connectedServices: [MusicServiceType] {
            musicServiceStates.compactMap { service, state in
                state.isConnected ? service : nil
            }
        }
        
    // MARK: - Initialization
    init(
        authManager: AuthManager,
        musicServiceManager: MusicServiceManager,
        errorHandler: ErrorHandler,
        loadingService: LoadingService,
        onLogout: @escaping () -> Void = {}
    ) {
        self.authManager = authManager
        self.musicServiceManager = musicServiceManager
        self.errorHandler = errorHandler
        self.loadingService = loadingService
        self.onLogout = onLogout
        
        bindPublishers()
        Task { await fetchInitialState() }
    }
            
    // MARK: - Auth & Service Methods
    func logout() {
        performOperation(
            context: "sign_out",
            operation: {
                self.authManager.signOut()
                self.musicServiceManager.disconnectAll()
                self.onLogout()
            },
            errorContext: "Sign Out"
        )
    }
    
    func connectMusicService(_ service: MusicServiceType) async {
        await performOperation(
            context: "connect_\(service)",
            operation: {
                guard self.user != nil else {
                    throw AppError.auth(.userNotFound)
                }
                
                try await self.musicServiceManager.connectService(service)
            },
            errorContext: "Connect \(service)"
        )
    }
    
    func disconnectMusicService(_ service: MusicServiceType) {
        performOperation(
            context: "disconnect_\(service)",
            operation: {
                guard self.connectedServices.contains(service) else {
                    return
                }
                self.musicServiceManager.disconnectService(service)
            },
            errorContext: "Disconnect \(service)"
        )
    }
    
    func restoreConnections() async {
        await performOperation(
            context: "restore_connections",
            operation: {
                guard self.user != nil else {
                    throw AppError.auth(.userNotFound)
                }
                await self.musicServiceManager.restoreConnections()
            },
            errorContext: "Restore Connections"
        )
    }
        
    // MARK: - Private Methods
    private func fetchInitialState() async {
        await performOperation(
            context: "restore_session",
            operation: {
                try await self.authManager.restoreLastSession()
                await self.musicServiceManager.restoreConnections()
            },
            errorContext: "Restore Session"
        )
    }
    
    // MARK: - Bindings
    private func bindPublishers() {
        authManager.$currentUser
            .receive(on: RunLoop.main)
            .assign(to: &$user)
        
        musicServiceManager.$connectionStates
            .receive(on: RunLoop.main)
            .assign(to: &$musicServiceStates)
    }
    
    // MARK: - Operation Helpers
    private func performOperation(
        context: String,
        operation: () async throws -> Void,
        errorContext: String
    ) async {
        loadingService.setLoading(true, context: context)
        defer { loadingService.setLoading(false, context: context) }
        
        do {
            try await operation()
        } catch {
            errorHandler.handle(error, context: errorContext)
        }
    }
    
    private func performOperation(
        context: String,
        operation: () throws -> Void,
        errorContext: String
    ) {
        loadingService.setLoading(true, context: context)
        defer { loadingService.setLoading(false, context: context) }
        
        do {
            try operation()
        } catch {
            errorHandler.handle(error, context: errorContext)
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
