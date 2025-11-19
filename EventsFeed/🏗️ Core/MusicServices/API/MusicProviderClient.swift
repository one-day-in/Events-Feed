import Foundation
import AuthenticationServices

final class MusicProviderClient: ObservableObject {
    private let service: MusicServiceType
    private let storage: MusicServiceTokenStore
    private let oAuth: OAuthFlow
    
    init(
        service: MusicServiceType,
        storage: MusicServiceTokenStore,
        oAuth: OAuthFlow
    ) {
        self.service = service
        self.storage = storage
        self.oAuth = oAuth
    }
    
    @MainActor
    func authenticate() async throws {
        switch service.config {
        case .oauth(let config):
            try await authenticateOAuth(with: config)
        case .native:
            try await authenticateAppleMusic()
        }
    }
    
    func disconnect() {
        if case .oauth = service.config {
            storage.removeToken(for: service)
        }
    }
    
    func checkAuthenticationStatus() -> Bool {
        switch service.config {
        case .oauth:
            return storage.getToken(for: service) != nil
        case .native:
            // Для Apple Music перевіряти системну аутентифікацію
            return false // або інша логіка для Apple Music
        }
    }
    
    // MARK: - Private OAuth Methods
    @MainActor
    private func authenticateOAuth(with config: OAuthConfig) async throws {
        let token = try await oAuth.authenticate(with: config)
        try storage.saveToken(token, for: service)
    }
    
    private func authenticateAppleMusic() async throws {
        print("Apple Music authenticated via system")
    }
}
