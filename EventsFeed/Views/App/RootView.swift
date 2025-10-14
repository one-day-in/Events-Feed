// Views/App/RootView.swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var errorService: ErrorService
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var stateManager: AppStateManager
    
    init() {
        // Створюємо StateObject з залежністю
        let sessionManager = DIContainer.shared.resolve(SessionManager.self)
        _stateManager = StateObject(wrappedValue: AppStateManager(sessionManager: sessionManager))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Головний контент
            if stateManager.appState == .ready {
                mainContent
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            
            // Loading View (початкове завантаження додатка)
            if stateManager.appState == .loading {
                LoadingView()
                    .transition(.opacity)
                    .zIndex(999)
            }
            
            // Auth Transition Overlay
            if stateManager.isShowingAuthTransition {
                AuthTransitionView(transitionState: stateManager.authTransitionState)
                    .transition(.opacity)
                    .zIndex(998)
            }
            
            // Auth Loading Overlay
            if stateManager.isLoadingAuth {
                AuthLoadingOverlay()
                    .transition(.opacity)
                    .zIndex(997)
            }
            
            // Error Banner
            if let error = errorService.currentError {
                ErrorBannerView(error: error) {
                    errorService.clearCurrentError()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1000)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: stateManager.appState)
        .animation(.easeInOut(duration: 0.3), value: sessionManager.isLoggedIn)
        .animation(.easeInOut(duration: 0.3), value: stateManager.isLoadingAuth)
        .animation(.easeInOut(duration: 0.3), value: stateManager.isShowingAuthTransition)
        .onAppear {
            stateManager.startAppFlow()
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var mainContent: some View {
        if sessionManager.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    let errorService = DIContainer.shared.resolve(ErrorService.self)
    let sessionManager = DIContainer.shared.resolve(SessionManager.self)
    
    return RootView()
        .environmentObject(errorService)
        .environmentObject(sessionManager)
}
