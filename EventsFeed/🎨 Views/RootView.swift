import SwiftUI

struct RootView: View {
    @EnvironmentObject private var loadingService: LoadingService
    @EnvironmentObject private var errorHandler: ErrorHandler
    let content: AnyView
    
    var body: some View {
        ZStack {
            // Фон
            AdaptiveBackgroundView()
            // 1. Основний контент (завжди на задньому плані)
            content
            
            // 2. Loading Overlay
            if loadingService.isLoading {
                Loader()
            }
            
            // 3. Error Banner
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

// MARK: - Previews
#Preview("Normal") {
    let container = DIContainer()
    let ls = container.resolve(LoadingService.self)
    let es = container.resolve(ErrorHandler.self)
    
    RootView(content: AnyView(
        VStack {
            Text("Основний контент")
                .font(.title)
            Text("Без завантаження та помилок")
                .foregroundColor(.gray)
        }
    ))
    .environmentObject(ls)
    .environmentObject(es)
}

#Preview("Loading") {
    let container = DIContainer()
    let ls = container.resolve(LoadingService.self)
    let es = container.resolve(ErrorHandler.self)
    
    return RootView(content: AnyView(
        VStack {
            Text("Основний контент")
                .font(.title)
            Text("Йде завантаження...")
                .foregroundColor(.gray)
        }
    ))
    .environmentObject(ls)
    .environmentObject(es)
}
