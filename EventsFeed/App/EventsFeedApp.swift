// App/EventsFeedApp.swift
import SwiftUI

@main
struct EventsFeedApp: App {
    @StateObject private var errorService: ErrorService
    @StateObject private var sessionManager: SessionManager
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Отримуємо з DI контейнера
        let errorService = DIContainer.shared.resolve(ErrorService.self)
        let sessionManager = DIContainer.shared.resolve(SessionManager.self)
        
        _errorService = StateObject(wrappedValue: errorService)
        _sessionManager = StateObject(wrappedValue: sessionManager)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(errorService)
                .environmentObject(sessionManager)
        }
    }
}
