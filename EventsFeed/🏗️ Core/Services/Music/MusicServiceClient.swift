import Foundation

class MusicServiceClient {
    let serviceType: MusicServiceType
    private let tokenStorage: TokenStorageProtocol
    private let constants: MusicServiceConstants?
    private let context: PresentationContextProviding
    
    init(
        serviceType: MusicServiceType,
        tokenStorage: TokenStorageProtocol,
        context: PresentationContextProviding
    ) {
        self.serviceType = serviceType
        self.tokenStorage = tokenStorage
        self.constants = MusicServiceConstants.forType(serviceType)
        self.context = context
    }
    
    @MainActor
    func authenticate() async throws {
        guard serviceType.isOAuthService, let constants = constants else { return }
        
        let webAuthHandler = WebAuthHandler(constants: constants, context: context)
        let (token, expiresIn) = try await webAuthHandler.authenticate()
        await saveAuthTokens(token: token, expiresIn: expiresIn)
    }
    
    func checkAuthenticationStatus() -> Bool {
        if serviceType.isOAuthService {
            let token = tokenStorage.get(serviceType.accessTokenKey)
            let isExpired = tokenStorage.isTokenExpired(expiryKey: serviceType.tokenExpiryKey)
            return token != nil && !isExpired
        } else {
            return performNativeAuthCheck()
        }
    }
    
    func disconnect() {
        guard serviceType.isOAuthService else { return }
        tokenStorage.remove(serviceType.accessTokenKey)
        tokenStorage.remove(serviceType.tokenExpiryKey)
    }
    
    func performNativeAuthCheck() -> Bool {
        return false
    }
    
    private func saveAuthTokens(token: String, expiresIn: TimeInterval?) async {
        tokenStorage.save(token, forKey: serviceType.accessTokenKey)
        if let expiresIn = expiresIn {
            tokenStorage.setTokenExpiry(expiryKey: serviceType.tokenExpiryKey, expiresIn: expiresIn)
        }
    }
}
