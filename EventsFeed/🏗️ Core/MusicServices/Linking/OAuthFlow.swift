import AuthenticationServices
import Foundation

final class OAuthFlow: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let pkceGenerator: PKCEGenerator
    
    init(
        pkceGenerator: PKCEGenerator
    ) {
        self.pkceGenerator = pkceGenerator
    }
    
    // MARK: - Public
    func authenticate(with config: OAuthConfig) async throws -> MusicServiceToken {
        let (verifier, challenge) = pkceGenerator.generate()
        
        let authURL = try buildAuthURL(config: config, challenge: challenge)
        let code = try await startWebFlow(config: config, url: authURL)
        
        return try await exchangeCodeForToken(config: config, code: code, verifier: verifier)
    }
    
    // MARK: - Build URL
    private func buildAuthURL(config: OAuthConfig, challenge: String) throws -> URL {
        var c = URLComponents(string: config.authURL)!
        var items: [URLQueryItem] = [
            .init(name: "client_id", value: config.clientID),
            
                .init(name: "response_type", value: "code"),
            .init(name: "redirect_uri", value: config.redirectURI),
            .init(name: "scope", value: config.scopes),
            .init(name: "code_challenge_method", value: "S256"),
            .init(name: "code_challenge", value: challenge)
        ]
        
        if let accessType = config.accessType {
            items.append(.init(name: "access_type", value: accessType))
        }
        if let prompt = config.prompt {
            items.append(.init(name: "prompt", value: prompt))
        }
        
        c.queryItems = items
        return c.url!
    }
    
    // MARK: - Web Flow
    private func startWebFlow(config: OAuthConfig, url: URL) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let callbackScheme = URL(string: config.redirectURI)!.scheme!
            let session = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: callbackScheme
            ) { callbackURL, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard
                    let url = callbackURL,
                    let code = URLComponents(url: url, resolvingAgainstBaseURL: true)?
                        .queryItems?.first(where: { $0.name == "code" })?.value
                else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                
                continuation.resume(returning: code)
            }
            
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
    }
    
    // MARK: - Exchange code → token
    private func exchangeCodeForToken(config: OAuthConfig, code: String, verifier: String) async throws -> MusicServiceToken {
        
        var req = URLRequest(url: URL(string: config.tokenURL)!)
        req.httpMethod = "POST"
        
        var params = URLComponents()
        params.queryItems = [
            .init(name: "grant_type", value: "authorization_code"),
            .init(name: "code", value: code),
            .init(name: "redirect_uri", value: config.redirectURI),
            .init(name: "client_id", value: config.clientID),
            .init(name: "code_verifier", value: verifier)
        ]
        
        req.httpBody = params.query?.data(using: .utf8)
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        let accessToken = json["access_token"] as! String
        let expiry = (json["expires_in"] as? Double).map { Date().addingTimeInterval($0) }
        
        return MusicServiceToken(accessToken: accessToken, expiry: expiry)
    }
    
    // MARK: - ASWebAuthenticationPresentationContextProviding
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.getKeyWindow() ?? ASPresentationAnchor()
    }
}
