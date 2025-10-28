import Foundation

enum AuthProvider: String, CaseIterable {
    case google
    case apple
    
    var displayName: String {
        switch self {
        case .google: return "Google"
        case .apple: return "Apple"
        }
    }
    
    var serviceName: String {
        return self.rawValue.capitalized
    }
}

enum GoogleSignInConstants {
    static var clientID: String {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GoogleClientID") as? String else {
            fatalError("Google Client ID not found in Info.plist")
        }
        return clientID
    }
}
