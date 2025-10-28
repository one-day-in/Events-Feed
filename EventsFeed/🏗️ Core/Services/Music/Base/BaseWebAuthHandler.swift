
import AuthenticationServices

class BaseWebAuthHandler: NSObject, ASWebAuthenticationPresentationContextProviding {
    private var authSession: ASWebAuthenticationSession?
    internal let constants: MusicServiceConstants
    
    init(constants: MusicServiceConstants) {
        self.constants = constants
    }
    
    func buildAuthURL(redirectURI: String) -> URL? {
        fatalError("Must be implemented by subclass")
    }
    
    func authenticateViaWeb() async throws -> String {
        guard let bundleID = Bundle.main.bundleIdentifier,
              let authURL = buildAuthURL(redirectURI: "\(bundleID)://\(constants.redirectURIScheme)")
        else {
            throw MusicServiceAuthError.invalidAuthURL
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            authSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: bundleID
            ) { callbackURL, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let callbackURL,
                      let code = self.extractCode(from: callbackURL) else {
                    continuation.resume(throwing: MusicServiceAuthError.noCallbackData)
                    return
                }
                continuation.resume(returning: code)
            }
            
            authSession?.presentationContextProvider = self
            authSession?.prefersEphemeralWebBrowserSession = true
            authSession?.start()
        }
    }
    
    func exchangeCodeForToken(code: String) async throws -> String {
        guard let tokenURL = URL(string: constants.tokenURL) else {
            throw MusicServiceAuthError.invalidAuthURL
        }
        
        var bodyParams: [String: String] = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": "\(Bundle.main.bundleIdentifier ?? "")://\(constants.redirectURIScheme)",
            "client_id": constants.clientID
        ]
        
        if let secret = constants.clientSecret {
            bodyParams["client_secret"] = secret
        }
        
        let bodyString = bodyParams
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accessToken = json["access_token"] as? String else {
            throw MusicServiceAuthError.tokenExchangeFailed
        }
        
        return accessToken
    }
    
    func extractCode(from url: URL) -> String? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == "code" })?
            .value
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

