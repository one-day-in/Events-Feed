import AuthenticationServices
import UIKit

final class SpotifyWebAuthHandler: BaseWebAuthHandler<SpotifyConstants> {
    
    override init() {
        super.init()
    }
    
    override func buildAuthURL(redirectURI: String) -> URL? {
        let codeVerifier = generateCodeVerifier()
        let codeChallenge = generateCodeChallenge(from: codeVerifier)
        
        self.codeVerifier = codeVerifier
        
        var components = URLComponents(string: SpotifyConstants.URLs.authBase)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: SpotifyConstants.clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "scope", value: SpotifyConstants.Scopes.all),
            URLQueryItem(name: "show_dialog", value: "true"),
            URLQueryItem(name: "state", value: generateState())
        ]
        
        return components?.url
    }
    
    override func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let codeVerifier = codeVerifier else {
            completion(.failure(MusicServiceAuthError.serviceError("Code verifier not found")))
            return
        }
        
        guard let tokenURL = URL(string: SpotifyConstants.URLs.token) else {
            completion(.failure(MusicServiceAuthError.invalidAuthURL))
            return
        }
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "client_id": SpotifyConstants.clientID,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": "\(Bundle.main.bundleIdentifier ?? "")://spotify-auth",
            "code_verifier": codeVerifier
        ]
        
        let bodyString = parameters.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }.joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        print("🔄 Making Spotify token exchange request...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Spotify token exchange error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(MusicServiceAuthError.tokenExchangeFailed))
                return
            }
            
            print("📡 Spotify response status: \(httpResponse.statusCode)")
            
            guard let data = data else {
                completion(.failure(MusicServiceAuthError.noAccessToken))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let accessToken = json["access_token"] as? String {
                        print("✅ Spotify access token received successfully!")
                        completion(.success(accessToken))
                    } else if let error = json["error"] as? String {
                        print("❌ Spotify token exchange failed: \(error)")
                        completion(.failure(MusicServiceAuthError.serviceError(error)))
                    } else {
                        completion(.failure(MusicServiceAuthError.tokenExchangeFailed))
                    }
                } else {
                    completion(.failure(MusicServiceAuthError.tokenExchangeFailed))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
