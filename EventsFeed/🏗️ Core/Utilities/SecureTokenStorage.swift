import Foundation

// MARK: - Token Storage Protocol
protocol TokenStorage {
    func save(_ value: String, forKey key: String)
    func get(_ key: String) -> String?
    func remove(_ key: String)
    func isTokenExpired(expiryKey: String) -> Bool
    func setTokenExpiry(expiryKey: String, expiresIn: TimeInterval)
}

// MARK: - Secure Token Storage
final class SecureTokenStorage: TokenStorage {
    private let keychainService: String
    
    init(service: String) {
        self.keychainService = service
    }
    
    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func remove(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func isTokenExpired(expiryKey: String) -> Bool {
            guard let expiryString = get(expiryKey),
                  let expiry = TimeInterval(expiryString) else {
                return true
            }
            return Date() >= Date(timeIntervalSince1970: expiry)
        }
        
    func setTokenExpiry(expiryKey: String, expiresIn: TimeInterval) {
        let expiry = Date().addingTimeInterval(expiresIn).timeIntervalSince1970
        save(String(expiry), forKey: expiryKey)
    }
}
