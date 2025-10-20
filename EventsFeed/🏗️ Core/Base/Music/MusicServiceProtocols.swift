import Foundation

protocol MusicServiceProtocol: ObservableObject {
    var isConnected: Bool { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }

    func authenticate()
    func handleAuthCallback(url: URL)
    func disconnect()
    func isAuthenticated() -> Bool
    func getAccessToken() -> String?
}

protocol MusicServiceConstants {
    static var clientID: String { get }
    static var redirectURIScheme: String { get }
    static var clientSecret: String? { get }
    static var requiresWebAuth: Bool { get }
    
    associatedtype UserDefaultsKeys: MusicServiceUserDefaultsKeys
    associatedtype Scopes: MusicServiceScopes
    associatedtype URLs: MusicServiceURLs
}

protocol MusicServiceUserDefaultsKeys {
    static var accessToken: String { get }
    static var refreshToken: String { get }
    static var tokenExpiry: String { get }
}

protocol MusicServiceScopes {
    static var all: String { get }
}

protocol MusicServiceURLs {
    static var authBase: String { get }
    static var token: String { get }
}
