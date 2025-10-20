import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private let service = "com.yourapp.EventsFeed.AppleAuth"
    
    private init() {}
    
    func saveAppleUserData(_ data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]
        
        // Спочатку видаляємо старий запис, якщо він існує
        SecItemDelete(query as CFDictionary)
        
        // Додаємо новий запис
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save Apple user data to Keychain: \(status)")
            return
        }
    }
    
    func getAppleUserData() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }
        
        return data
    }
    
    func deleteAppleUserData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
