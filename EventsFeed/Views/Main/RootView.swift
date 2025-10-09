import SwiftUI

struct RootView: View {
    @EnvironmentObject private var errorService: ErrorService
    @EnvironmentObject private var sessionManager: CoordinatedSessionManager
    @StateObject private var viewModel: RootViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.resolve(RootViewModel.self))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                Group {
                    if sessionManager.isLoggedIn {
                        MainTabView()
                    } else {
                        LoginView()
                    }
                }
                .opacity(viewModel.isLoading ? 0 : 1)
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            
            if let error = errorService.currentError {
                ErrorBannerView(error: error) {
                    errorService.clearCurrentError()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.horizontal)
                .padding(.top, 5)
                .zIndex(999)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.3), value: sessionManager.isLoggedIn)
        .onAppear {
            viewModel.startLoadingSequence()
        }
    }
}

#Preview {
    let errorService = DIContainer.shared.resolve(ErrorService.self)
    let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
    
    RootView()
        .environmentObject(errorService)
        .environmentObject(sessionManager)
}
