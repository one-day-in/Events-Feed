import AuthenticationServices
import CryptoKit

final class WebAuthHandler: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let constants: MusicServiceConstants

    init(constants: MusicServiceConstants) {
        self.constants = constants
        super.init()
    }

    func authenticate() async throws -> (String, TimeInterval?) {
        let (verifier, challenge) = generatePKCE()
        guard let authURL = buildAuthURL(codeChallenge: challenge) else {
            throw URLError(.badURL)
        }
        guard let callbackScheme = URL(string: constants.redirectURI)?.scheme else {
            throw URLError(.badURL)
        }

        let code = try await performWebAuth(authURL: authURL, callbackScheme: callbackScheme)
        let (token, expiresIn) = try await exchangeCodeForToken(code: code, codeVerifier: verifier)
        return (token, expiresIn)
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.rootViewController?.view.window ?? UIWindow()
    }

    private func buildAuthURL(codeChallenge: String) -> URL? {
        var components = URLComponents(string: constants.authBaseURL)
        var queryItems = [
            URLQueryItem(name: "client_id", value: constants.clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: constants.redirectURI),
            URLQueryItem(name: "scope", value: constants.scopes),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: codeChallenge)
        ]
        
        if constants.serviceType == .youtubeMusic {
            queryItems.append(contentsOf: [
                URLQueryItem(name: "access_type", value: "offline"),
                URLQueryItem(name: "prompt", value: "consent")
            ])
        }
        
        components?.queryItems = queryItems
        return components?.url
    }

    private func performWebAuth(authURL: URL, callbackScheme: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: callbackScheme
            ) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let callbackURL = callbackURL,
                      let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                      let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
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
    
    private func exchangeCodeForToken(code: String, codeVerifier: String) async throws -> (String, TimeInterval?) {
        var req = URLRequest(url: URL(string: constants.tokenURL)!)
        req.httpMethod = "POST"
        let bodyParams: [String: String] = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": constants.redirectURI,
            "client_id": constants.clientID,
            "code_verifier": codeVerifier
        ]
        req.httpBody = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")" }
            .joined(separator: "&").data(using: .utf8)
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let token = json?["access_token"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        let expiresIn = (json?["expires_in"] as? NSNumber)?.doubleValue
        return (token, expiresIn)
    }

    // PKCE
    private func generatePKCE() -> (String, String) {
        let verifier = randomString(length: 64)
        let digest = SHA256.hash(data: Data(verifier.utf8))
        let challenge = Data(digest).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return (verifier, challenge)
    }

    private func randomString(length: Int) -> String {
        let chars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return String((0..<length).map { _ in chars.randomElement()! })
    }
}
