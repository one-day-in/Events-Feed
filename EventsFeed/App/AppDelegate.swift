import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("✅ Додаток запущено")
        initializeEssentialServices()
        
        return true
    }
    
    private func initializeEssentialServices() {
        print("🔄 AppDelegate: ініціалізація основних сервісів")
        
        let errorService = DIContainer.shared.resolve(ErrorService.self)
        let sessionManager = DIContainer.shared.resolve(SessionManager.self)
        
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
        if url.absoluteString.contains("spotify") {
            print("✅ URL оброблено Spotify")
            
            let spotifyClient = DIContainer.shared.resolve(SpotifyServiceClient.self)
            spotifyClient.handleAuthCallback(url: url)
            
            return true
        }
        
        // 2. Обробка YouTube Music callback
        if url.scheme == "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s" {
            print("✅ URL оброблено YouTube Music")
            
            let youTubeMusicClient = DIContainer.shared.resolve(YouTubeMusicServiceClient.self)
            youTubeMusicClient.handleAuthCallback(url: url)
            
            return true
        }
                
        // 3. Обробка Google Sign-In
        let authManager = DIContainer.shared.resolve(AuthManager.self)
        if authManager.handle(url) {
            print("✅ URL оброблено Google Sign-In")
            return true
        }
        
        print("❌ URL не розпізнано: \(url)")
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("📱 Додаток став активним")
        // Можна додати відновлення сесії при активізації додатка
        Task { @MainActor in
            let sessionManager = DIContainer.shared.resolve(SessionManager.self)
            await sessionManager.restoreSession()
        }
    }
}
