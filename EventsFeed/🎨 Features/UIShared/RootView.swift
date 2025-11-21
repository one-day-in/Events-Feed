import SwiftUI

struct RootView: View {

    @ObservedObject private var loadingService: LoadingService
    @ObservedObject private var errorHandler: ErrorHandler

    let content: AnyView
    
    init(
        content: AnyView,
        loadingService: LoadingService,
        errorHandler: ErrorHandler
    ) {
        self.content = content
        self.loadingService = loadingService
        self.errorHandler = errorHandler
    }

    var body: some View {
        ZStack {
            AdaptiveBackgroundView()

            // Main content
            content

            // Loading Overlay
            if loadingService.isLoading {
                Loader()
            }

            // Error Banner
            if let error = errorHandler.currentError {
                ErrorBannerView(error: error) {
                    errorHandler.clearCurrent()
                }
            }
        }
        .animation(.default, value: loadingService.isLoading)
        .animation(.spring(response: 2.0), value: errorHandler.currentError != nil)
    }
}
