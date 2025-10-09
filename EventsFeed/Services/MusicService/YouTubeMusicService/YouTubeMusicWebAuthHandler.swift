import AuthenticationServices
import UIKit

final class YouTubeMusicWebAuthHandler: BaseWebAuthHandler<YouTubeMusicConstants> {
    
    override init() {
        super.init()
    }
    
    override func buildAuthURL(redirectURI: String) -> URL? {
        var components = URLComponents(string: YouTubeMusicConstants.URLs.authBase)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: YouTubeMusicConstants.clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: YouTubeMusicConstants.Scopes.all),
            URLQueryItem(name: "access_type", value: "offline"),
            URLQueryItem(name: "include_granted_scopes", value: "true"),
            URLQueryItem(name: "state", value: generateState()),
            URLQueryItem(name: "prompt", value: "consent")
        ]
        
        guard let url = components?.url else {
            print("❌ Не вдалося створити URL для авторизації YouTube Music")
            return nil
        }
        
        return url
    }
    
    override func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let tokenURL = URL(string: YouTubeMusicConstants.URLs.token) else {
            completion(.failure(MusicServiceAuthError.invalidAuthURL))
            return
        }
        
        // ВИПРАВЛЕННЯ: Використовуємо той самий redirect URI що і в авторизації
        let redirectURI = "\(YouTubeMusicConstants.redirectURIScheme):/oauth2redirect"
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "client_id": YouTubeMusicConstants.clientID,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI
        ]
        
        let bodyString = parameters.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }.joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        print("🔄 YouTube Music: Відправляємо запит на отримання токена...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ YouTube Music: Помилка мережі: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(MusicServiceAuthError.tokenExchangeFailed))
                return
            }
            
            print("📡 YouTube Music: Статус відповіді: \(httpResponse.statusCode)")
            
            guard let data = data else {
                completion(.failure(MusicServiceAuthError.noAccessToken))
                return
            }
            
            // Додатковий лог для відладки
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 YouTube Music: Відповідь сервера: \(responseString.prefix(200))...")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let accessToken = json["access_token"] as? String {
                        print("✅ YouTube Music: Токен доступу успішно отримано!")
                        
                        if let refreshToken = json["refresh_token"] as? String {
                            YouTubeMusicTokenStorage().saveRefreshToken(refreshToken)
                        }
                        
                        if let expiresIn = json["expires_in"] as? TimeInterval {
                            let expiryDate = Date().addingTimeInterval(expiresIn)
                            YouTubeMusicTokenStorage().saveTokenExpiry(expiryDate)
                        }
                        
                        YouTubeMusicTokenStorage().saveAccessToken(accessToken)
                        completion(.success(accessToken))
                        
                    } else if let error = json["error"] as? String {
                        let errorDescription = json["error_description"] as? String ?? error
                        print("❌ YouTube Music: Помилка авторизації: \(error) - \(errorDescription)")
                        completion(.failure(MusicServiceAuthError.serviceError("\(error): \(errorDescription)")))
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
