import UIKit
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("✅ Додаток запущено")
        
        // Базова ініціалізація сервісів
        initializeEssentialServices()
        
        return true
    }
    
    private func initializeEssentialServices() {
        print("🔄 AppDelegate: ініціалізація основних сервісів")
        
        let errorService = DIContainer.shared.resolve(ErrorService.self)
        let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
        
        print("   ErrorService instance: \(ObjectIdentifier(errorService))")
        print("   SessionManager instance: \(ObjectIdentifier(sessionManager))")
        
        print("✅ AppDelegate: основні сервіси ініціалізовано")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: .appInitializationCompleted, object: nil)
            print("📢 AppDelegate: сповіщення про ініціалізацію відправлено")
        }
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        print("🔗 Обробка URL: \(url)")
        
        // 1. Обробка Spotify callback
        if url.absoluteString.contains("spotify-auth") {
            print("✅ URL оброблено Spotify")
            
            // Отримуємо SpotifyServiceClient через DI контейнер
            let spotifyClient = DIContainer.shared.resolve(SpotifyServiceClient.self)
            spotifyClient.handleAuthCallback(url: url)
            
            return true
        }
        
        // 2. Обробка YouTube Music callback
        if url.scheme == "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s" {
            print("✅ URL оброблено YouTube Music")
            
            // Отримуємо YouTubeMusicServiceClient через DI контейнер
            let youTubeMusicClient = DIContainer.shared.resolve(YouTubeMusicServiceClient.self)
            youTubeMusicClient.handleAuthCallback(url: url)
            
            return true
        }
        
        // 3. Обробка Google Sign-In
        let authService = DIContainer.shared.resolve(AuthServiceProtocol.self)
        if authService.handle(url) {
            print("✅ URL оброблено Google Sign-In")
            return true
        }
        
        print("❌ URL не розпізнано: \(url)")
        return false
    }
}
