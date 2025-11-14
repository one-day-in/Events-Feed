import Foundation

class MusicServiceClient: TokenStorageClient {
    let serviceType: MusicServiceType
    let tokenStorage: TokenStorageProtocol
    private let constants: MusicServiceConstants?
    
    init(serviceType: MusicServiceType,
         constants: MusicServiceConstants? = nil,
         tokenStorage: TokenStorageProtocol = SecureTokenStorage(service: "MusicService")) {
        self.serviceType = serviceType
        self.constants = constants
        self.tokenStorage = tokenStorage
    }
    
    func authenticate() async throws {
        guard serviceType.isOAuthService, let constants = constants else { return }
        
        let webAuthHandler = await WebAuthHandler(constants: constants)
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
