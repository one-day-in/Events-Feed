import Foundation

final class MusicServiceTokenStore {
    private let keychain: KeychainHelper
    private let keychainService: String
    
    init(keychain: KeychainHelper) {
        self.keychain = keychain
        self.keychainService = Bundle.main.bundleIdentifier ?? "concertbox"
    }
    
    func saveToken(_ token: MusicServiceToken, for service: MusicServiceType) throws {
        guard case .oauth(let oauthConfig) = service.config else { return }
        
        try keychain.save(token, for: oauthConfig.storageKey, service: keychainService)
    }
    
    func getToken(for service: MusicServiceType) -> MusicServiceToken? {
        guard case .oauth(let oauthConfig) = service.config else { return nil }
        
        return keychain.read(MusicServiceToken.self, for: oauthConfig.storageKey, service: keychainService)
    }
    
    func removeToken(for service: MusicServiceType) {
        guard case .oauth(let oauthConfig) = service.config else { return }
        
        keychain.delete(for: oauthConfig.storageKey, service: keychainService)
    }
}
