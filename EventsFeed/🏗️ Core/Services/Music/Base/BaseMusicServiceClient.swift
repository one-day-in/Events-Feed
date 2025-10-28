import Foundation

class BaseMusicServiceClient: ObservableObject, MusicServiceProtocol {
    @Published private(set) var isConnected = false
    let serviceType: MusicServiceType
    
    internal let webAuthHandler: BaseWebAuthHandler?
    private let tokenStorage: TokenStorage
    
    init(
        serviceType: MusicServiceType,
        webAuthHandler: BaseWebAuthHandler?,
        tokenStorage: TokenStorage = SecureTokenStorage(service: "MusicService")
    ) {
        self.serviceType = serviceType
        self.webAuthHandler = webAuthHandler
        self.tokenStorage = tokenStorage
        updateConnectionState()
    }
    
    // MARK: - Public API
    
    func authenticate() async throws {
        guard let handler = webAuthHandler else {
            throw MusicServiceAuthError.notImplemented
        }
        
        let code = try await handler.authenticateViaWeb()
        let token = try await handler.exchangeCodeForToken(code: code)
        saveAccessToken(token)
        await updateState(connected: true)
    }
    
    func handleAuthCallback(url: URL) async throws -> Bool {
        guard let handler = webAuthHandler else { return false }
        guard let code = await handler.extractCode(from: url) else {
            throw MusicServiceAuthError.noCallbackData
        }
        
        let token = try await handler.exchangeCodeForToken(code: code)
        saveAccessToken(token)
        await updateState(connected: true)
        return true
    }
    
    func disconnect() {
        clearTokens()
        Task { @MainActor in
            updateState(connected: false)
        }
    }
    
    // MARK: - Session Restoration
    
    func restoreSession() async throws {
        print("🎵 Checking \(serviceType.rawValue) session...")
        
        if isAuthenticated() {
            print("🎵 \(serviceType.rawValue) session is valid")
            await updateState(connected: true)
        } else {
            print("🎵 \(serviceType.rawValue) session expired or invalid")
            await updateState(connected: false)
            throw MusicServiceAuthError.tokenExpired
        }
    }
    
    // MARK: - Helpers
    
    private func updateConnectionState() {
        isConnected = isAuthenticated()
    }
    
    internal func isAuthenticated() -> Bool {
        guard let token = getAccessToken(), !isTokenExpired() else { return false }
        return !token.isEmpty
    }
    
    @MainActor
    internal func updateState(connected: Bool) {
        self.isConnected = connected
    }
}

// MARK: - Token Management
extension BaseMusicServiceClient {
    func saveAccessToken(_ token: String) {
        tokenStorage.save(token, forKey: serviceType.accessTokenKey)
        tokenStorage.setTokenExpiry(expiryKey: serviceType.tokenExpiryKey, expiresIn: 3600)
    }
    
    func getAccessToken() -> String? {
        tokenStorage.get(serviceType.accessTokenKey)
    }
    
    func clearTokens() {
        [serviceType.accessTokenKey, serviceType.refreshTokenKey, serviceType.tokenExpiryKey]
            .forEach { tokenStorage.remove($0) }
    }
    
    private func isTokenExpired() -> Bool {
        tokenStorage.isTokenExpired(expiryKey: serviceType.tokenExpiryKey)
    }
}

