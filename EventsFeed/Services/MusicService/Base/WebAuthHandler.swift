import AuthenticationServices
import CryptoKit
import CommonCrypto

class BaseWebAuthHandler<Constants: MusicServiceConstants>: NSObject, ASWebAuthenticationPresentationContextProviding {
    private var authSession: ASWebAuthenticationSession?
    private var completion: ((Result<String, Error>) -> Void)?
    internal var codeVerifier: String?
    
    func authenticateViaWeb(completion: @escaping (Result<String, Error>) -> Void) {
        self.completion = completion
        
        let redirectURI: String
        let callbackURLScheme: String
        
        // Визначаємо тип сервісу за scheme
        if Constants.redirectURIScheme.contains("googleusercontent") {
            // YouTube Music - використовуємо повний scheme
            redirectURI = "\(Constants.redirectURIScheme):/oauth2redirect"
            callbackURLScheme = Constants.redirectURIScheme
        } else {
            // Spotify та інші - використовуємо bundle ID
            guard let bundleID = Bundle.main.bundleIdentifier else {
                completion(.failure(MusicServiceAuthError.failedToGetBundleID))
                return
            }
            redirectURI = "\(bundleID)://\(Constants.redirectURIScheme)"
            callbackURLScheme = bundleID
        }
        
        guard let authURL = buildAuthURL(redirectURI: redirectURI) else {
            completion(.failure(MusicServiceAuthError.invalidAuthURL))
            return
        }
        
        print("🎵 Запуск авторизації \(Constants.self)")
        print("🔗 Auth URL: \(authURL)")
        print("📱 Callback Scheme: \(callbackURLScheme)")
        print("🔄 Redirect URI: \(redirectURI)")
        
        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackURLScheme
        ) { [weak self] callbackURL, error in
            self?.authSession = nil
            
            if let error = error {
                print("❌ Auth Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let callbackURL = callbackURL else {
                print("❌ No callback URL received")
                completion(.failure(MusicServiceAuthError.noCallbackData))
                return
            }
            
            print("✅ Отримано callback URL: \(callbackURL)")
            self?.handleCallback(url: callbackURL, completion: completion)
        }
        
        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = true
        
        if !(authSession?.start() ?? false) {
            completion(.failure(MusicServiceAuthError.failedToStartSession))
        }
    }
    
    func handleCallback(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        print("🎵 Processing callback: \(url)")
        
        if let query = url.query, !query.isEmpty {
            print("🔍 Found query data: \(query)")
            let parameters = parseQueryParameters(query)
            
            if let code = parameters["code"] {
                print("✅ Authorization code received: \(code.prefix(10))...")
                exchangeCodeForToken(code: code, completion: completion)
                return
            } else if let error = parameters["error"] {
                print("❌ Error in query: \(error)")
                completion(.failure(MusicServiceAuthError.serviceError(error)))
                return
            }
        }
        
        print("❌ No authorization code found in URL")
        completion(.failure(MusicServiceAuthError.noAccessToken))
    }
    
    // MARK: - Контекст презентації
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
    
    // MARK: - Методи для перевизначення в конкретних сервісах
    
    func buildAuthURL(redirectURI: String) -> URL? {
        // Базова реалізація - має бути перевизначена
        return nil
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Базова реалізація - має бути перевизначена
        completion(.failure(MusicServiceAuthError.notImplemented))
    }
    
    // MARK: - Допоміжні методи PKCE
    
    func generateCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    func generateCodeChallenge(from verifier: String) -> String {
        guard let verifierData = verifier.data(using: .ascii) else { return "" }
        
        if #available(iOS 13.0, *) {
            let hashed = SHA256.hash(data: verifierData)
            return Data(hashed).base64EncodedString()
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            _ = verifierData.withUnsafeBytes { bytes in
                CC_SHA256(bytes.baseAddress, CC_LONG(verifierData.count), &digest)
            }
            return Data(digest).base64EncodedString()
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        }
    }
    
    func parseQueryParameters(_ query: String) -> [String: String] {
        var parameters: [String: String] = [:]
        let pairs = query.components(separatedBy: "&")
        
        for pair in pairs {
            let components = pair.components(separatedBy: "=")
            if components.count == 2 {
                let key = components[0]
                let value = components[1].removingPercentEncoding ?? components[1]
                parameters[key] = value
            }
        }
        
        return parameters
    }
    
    func generateState() -> String {
        return UUID().uuidString
    }
}

