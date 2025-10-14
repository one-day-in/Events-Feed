// AppleMusicAuthHandler.swift
import Foundation
import AuthenticationServices

final class AppleMusicAuthHandler: BaseWebAuthHandler<AppleMusicConstants> {
    
    // Для Apple Music web auth не потрібен
    override func authenticateViaWeb(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.failure(MusicServiceAuthError.notImplemented))
    }
    
    override func buildAuthURL(redirectURI: String) -> URL? {
        return nil
    }
    
    override func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.failure(MusicServiceAuthError.notImplemented))
    }
}
