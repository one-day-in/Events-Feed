import SwiftUI

struct RootView: View {
    @StateObject private var appStateManager = DIContainer.shared.resolve(AppStateManager.self)
    
    var body: some View {
        ZStack {
            // Основний контент
            switch appStateManager.appPhase {
            case .splash:
                AnimatedSplashView(onSplashComplete: {
                                    appStateManager.completeSplashPhase()
                                })
                
            case .ready:
                switch appStateManager.appState {
                case .unauthenticated:
                    Text("Auth")
//                    AuthView()
                case .authenticated:
                    Text("Main")
//                    MainTabView()
                }
            }
        }
        // В RootView.swift
        .withGlobalHandlers(
            isLoading: appStateManager.appPhase == .ready ? appStateManager.isLoading : false,
            errorService: DIContainer.shared.resolve(ErrorService.self)
        )
        .onAppear {
            if case .splash = appStateManager.appPhase {
                Task { await appStateManager.startApp() }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    return RootView()

}
