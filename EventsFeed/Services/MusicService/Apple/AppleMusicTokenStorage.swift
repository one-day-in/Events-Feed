// AppleMusicTokenStorage.swift
import Foundation
import MusicKit

final class AppleMusicTokenStorage: BaseTokenStorage<AppleMusicConstants> {
    
    func saveDeveloperToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: AppleMusicConstants.UserDefaultsKeys.developerToken)
    }
    
    func getDeveloperToken() -> String? {
        return UserDefaults.standard.string(forKey: AppleMusicConstants.UserDefaultsKeys.developerToken)
    }
    
    override func clearTokens() {
        super.clearTokens()
        UserDefaults.standard.removeObject(forKey: AppleMusicConstants.UserDefaultsKeys.developerToken)
    }
    
    // Для Apple Music перевіряємо статус авторизації MusicKit
    override func isTokenValid() -> Bool {
        return MusicAuthorization.currentStatus == .authorized
    }
}
