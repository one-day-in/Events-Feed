import SwiftUI

class RootViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var appInitialized = false
    
    private let sessionManager: CoordinatedSessionManager
    
    init(sessionManager: CoordinatedSessionManager) {
        self.sessionManager = sessionManager
    }
    
    func startLoadingSequence() {
        print("🚀 RootViewModel: початок завантаження")
        
        // 1. Мінімальний час показу loading screen (2 секунди)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.appInitialized = true
            self.checkIfCanProceedToMainApp()
        }
        
        // 2. Додатково перевіряємо стан sessionManager
        self.checkSessionManagerStatus()
        
        // 3. Слухаємо нотифікацію про завершення ініціалізації AppDelegate
        NotificationCenter.default.addObserver(
            forName: .appInitializationCompleted,
            object: nil,
            queue: .main
        ) { _ in
            print("📱 RootViewModel: отримано нотифікацію про ініціалізацію AppDelegate")
            self.appInitialized = true
            self.checkIfCanProceedToMainApp()
        }
    }
    
    private func checkSessionManagerStatus() {
        // Якщо sessionManager вже завершив завантаження
        if !sessionManager.isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkIfCanProceedToMainApp()
            }
        } else {
            // Якщо sessionManager ще завантажується, перевіряємо через 3 секунди (fallback)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                print("⏰ RootViewModel: fallback перевірка стану")
                self.checkIfCanProceedToMainApp()
            }
        }
    }
    
    private func checkIfCanProceedToMainApp() {
        let canProceed = appInitialized && !sessionManager.isLoading
        
        if canProceed && isLoading {
            print("✅ RootViewModel: умови для переходу виконані")
            print("   - appInitialized: \(appInitialized)")
            print("   - sessionManager.isLoading: \(sessionManager.isLoading)")
            
            // Запускаємо анімацію завершення завантаження
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    self.isLoading = false
                }
            }
        } else {
            print("⏳ RootViewModel: очікуємо на умови")
            print("   - appInitialized: \(appInitialized)")
            print("   - sessionManager.isLoading: \(sessionManager.isLoading)")
        }
    }
    
    func checkIfCanHideLoading() -> Bool {
        return appInitialized && !sessionManager.isLoading
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
