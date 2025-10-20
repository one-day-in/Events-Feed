import Foundation

class BaseMusicServiceClient<
    Constants: MusicServiceConstants,
    AuthHandler: BaseWebAuthHandler<Constants>,
    TokenStorage: BaseTokenStorage<Constants>
>: ObservableObject, MusicServiceProtocol {
    
    // MARK: - Dependencies
    internal let webAuthHandler: AuthHandler
    internal let tokenStorage: TokenStorage
    internal let errorService: ErrorService
    internal let serviceType: MusicServiceType
    
    // MARK: - Published
    @Published public var isConnected = false
    @Published public var errorMessage: String? = nil
    @Published public var isLoading = false
    
    // MARK: - Init
    init(
        webAuthHandler: AuthHandler,
        tokenStorage: TokenStorage,
        errorService: ErrorService,
        serviceType: MusicServiceType
    ) {
        self.webAuthHandler = webAuthHandler
        self.tokenStorage = tokenStorage
        self.errorService = errorService
        self.serviceType = serviceType
        
        updateConnectionState()
    }
    
    // MARK: - Public API
    
    func authenticate() {
        Task { @MainActor in
            isLoading = true
            errorMessage = nil
        }
        authenticateViaWeb()
    }
    
    func handleAuthCallback(url: URL) {
        webAuthHandler.handleCallback(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                self.handleAuthSuccess(accessToken: token)
            case .failure(let error):
                self.handleError(error.localizedDescription)
            }
        }
    }
    
    func disconnect() {
        tokenStorage.clearTokens()
        
        Task { @MainActor in
            self.isConnected = false
            self.isLoading = false
        }
        
        print("🔌 Відключено від \(serviceType.rawValue)")
        postDisconnected()
        postConnectionStateChanged()
    }
    
    func isAuthenticated() -> Bool {
        tokenStorage.getAccessToken() != nil
    }
    
    func getAccessToken() -> String? {
        tokenStorage.getAccessToken()
    }
    
    // MARK: - Internal Logic
    
    internal func authenticateViaWeb() {
        webAuthHandler.authenticateViaWeb() { [weak self] result in
            guard let self = self else { return }
            
            Task { @MainActor in self.isLoading = false }
            
            switch result {
            case .success(let token):
                self.handleAuthSuccess(accessToken: token)
            case .failure(let error):
                self.handleError(error.localizedDescription)
            }
        }
    }
    
    internal func handleAuthSuccess(accessToken: String) {
        tokenStorage.saveAccessToken(accessToken)
        print("✅ Успішна автентифікація \(serviceType.rawValue)!")
        
        Task { @MainActor in
            self.isConnected = true
            self.isLoading = false
            self.errorMessage = nil
        }
        
        errorService.clearCurrentError()
        postAuthSuccess()
        postConnectionStateChanged()
    }
    
    internal func handleError(_ message: String) {
        print("❌ Помилка \(serviceType.rawValue): \(message)")
        
        // оновлюємо UI-стан
        Task { @MainActor in
            self.errorMessage = message
            self.isLoading = false
        }
        
        // репортуємо централізовано
        errorService.report(
            MusicServiceAuthError.serviceError(message),
            context: "[\(serviceType.rawValue)Client.handleError]",
            serviceType: serviceType
        )
        
        postAuthError(message)
    }
    
    internal func updateConnectionState() {
        let newState = isAuthenticated()
        Task { @MainActor in self.isConnected = newState }
        postConnectionStateChanged()
    }
}

// MARK: - Notifications
extension BaseMusicServiceClient {
    
    internal func postAuthSuccess() {
        NotificationCenter.default.post(
            name: .musicServiceAuthSuccess,
            object: nil,
            userInfo: [
                NotificationKeys.serviceType: serviceType,
                NotificationKeys.accessToken: getAccessToken() ?? ""
            ]
        )
    }
    
    internal func postAuthError(_ message: String) {
        NotificationCenter.default.post(
            name: .musicServiceAuthError,
            object: nil,
            userInfo: [
                NotificationKeys.serviceType: serviceType,
                NotificationKeys.errorMessage: message
            ]
        )
    }
    
    internal func postDisconnected() {
        NotificationCenter.default.post(
            name: .musicServiceDisconnected,
            object: nil,
            userInfo: [
                NotificationKeys.serviceType: serviceType
            ]
        )
    }
    
    internal func postConnectionStateChanged() {
        NotificationCenter.default.post(
            name: .musicServiceConnectionStateChanged,
            object: nil,
            userInfo: [
                NotificationKeys.serviceType: serviceType,
                NotificationKeys.isConnected: isAuthenticated()
            ]
        )
    }
}
