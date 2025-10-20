import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    private var notificationService: NotificationService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("✅ Додаток запущено")
        
        _ = DIContainer.shared
        
        initializeSafeServices()
        return true
    }
    
    private func initializeSafeServices() {
        print("🔄 AppDelegate: ініціалізація безпечних сервісів")
        
        // Отримуємо тільки сервіси, які не мають складних залежностей
        self.notificationService = DIContainer.shared.resolve(NotificationService.self)
        
        print("✅ AppDelegate: безпечні сервіси ініціалізовано")
        
        // Сповіщення про ініціалізацію
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.notificationService?.postAppInitialized()
            print("📢 AppDelegate: сповіщення про ініціалізацію відправлено")
        }
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        print("🔗 Обробка URL: \(url)")
        
        // Безпечний резолв тільки при необхідності
        if url.absoluteString.contains("spotify") {
            print("✅ URL оброблено Spotify")
            let spotifyClient = DIContainer.shared.resolve(SpotifyServiceClient.self)
            spotifyClient.handleAuthCallback(url: url)
            return true
        }
        
        if url.scheme == "com.googleusercontent.apps.487751122186-3jkc1mkdi0pfr82kcpjtnipv470utl1s" {
            print("✅ URL оброблено YouTube Music")
            let youTubeMusicClient = DIContainer.shared.resolve(YouTubeMusicServiceClient.self)
            youTubeMusicClient.handleAuthCallback(url: url)
            return true
        }
        
        // Обробка Google Sign-In
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
        
        // Тепер безпечно резолвити всі залежності
        Task { @MainActor in
            let sessionManager = DIContainer.shared.resolve(SessionManager.self)
            await sessionManager.restoreSession()
        }
    }
}
