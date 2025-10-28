import SwiftUI

extension View {
    // MARK: - Loading Overlay
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.regularMaterial)
                                .shadow(color: .black.opacity(0.15), radius: 10)
                        )
                }
                .transition(.opacity)
            }
        }
    }
    
    // MARK: - Error Banner Overlay
    func errorBanner(errorService: UIErrorService) -> some View {
        ZStack(alignment: .top) {
            self
            
            if let appError = errorService.currentError {
                VStack {
                    ErrorBannerView(error: appError) {
                        withAnimation {
                            errorService.clearError()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            errorService.clearError()
                        }
                    }
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: errorService.currentError)
    }

    // MARK: - Combined Handler
    func withGlobalHandlers(loadingService: LoadingService, errorService: UIErrorService) -> some View {
        self
            .loadingOverlay(isLoading: loadingService.isLoading)
            .errorBanner(errorService: errorService)
    }
}
