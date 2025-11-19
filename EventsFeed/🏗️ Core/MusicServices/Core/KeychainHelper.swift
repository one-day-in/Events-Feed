import Foundation
import Security

final class KeychainHelper {
    
    // MARK: - Basic CRUD Operations
    func save<T: Codable>(_ item: T, for key: String, service: String) throws {
        let data = try JSONEncoder().encode(item)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainHelper", code: Int(status))
        }
    }
    
    func read<T: Codable>(_ type: T.Type, for key: String, service: String) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(for key: String, service: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    // MARK: - Batch Operations
    func getAllKeys(service: String) -> [String] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var items: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &items)
        
        guard status == errSecSuccess, let itemsArray = items as? [[String: Any]] else { return [] }
        
        return itemsArray.compactMap { $0[kSecAttrAccount as String] as? String }
    }
    
    func clearAll(service: String) {
        let keys = getAllKeys(service: service)
        for key in keys {
            delete(for: key, service: service)
        }
    }
    
    // MARK: - Existence Check
    func exists(for key: String, service: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false
        ]
        
        return SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess
    }
}
