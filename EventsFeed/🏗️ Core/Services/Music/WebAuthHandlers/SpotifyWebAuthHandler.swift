import Foundation
import AuthenticationServices

final class SpotifyWebAuthHandler: BaseWebAuthHandler {
    
    override func buildAuthURL(redirectURI: String) -> URL? {
        guard var comps = URLComponents(string: constants.authBaseURL) else { return nil }
        comps.queryItems = [
            URLQueryItem(name: "client_id", value: constants.clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: constants.scopes),
            URLQueryItem(name: "show_dialog", value: "true")
        ]
        return comps.url
    }
}
