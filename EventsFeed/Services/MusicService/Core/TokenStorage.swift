import Foundation

// Універсальне сховище токенів для всіх музичних сервісів
class BaseTokenStorage<Constants: MusicServiceConstants> {
    
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaultsKeys.accessToken)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.accessToken)
    }
    
    func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserDefaultsKeys.refreshToken)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.refreshToken)
    }
    
    func saveTokenExpiry(_ expiry: Date) {
        UserDefaults.standard.set(expiry, forKey: Constants.UserDefaultsKeys.tokenExpiry)
    }
    
    func getTokenExpiry() -> Date? {
        return UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.tokenExpiry) as? Date
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.refreshToken)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.tokenExpiry)
    }
    
    func isTokenValid() -> Bool {
        guard let expiry = getTokenExpiry() else { return false }
        return expiry > Date()
    }
}
