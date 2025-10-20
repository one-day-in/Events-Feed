//// MainTabView.swift
//import SwiftUI
//
//struct MainTabView: View {
//    @StateObject var viewModel: MainTabViewModel
//    @EnvironmentObject private var sessionManager: SessionManager
//    
//    var body: some View {
//        TabView(selection: $viewModel.selectedTab) {
//            EventsFeedView(viewModel: DIContainer.shared.resolve(EventsFeedManager.self))
//                .tabItem {
//                    Image(systemName: viewModel.selectedTab == 0 ? "music.note.square.stack.fill" : "music.note.square.stack")
//                    Text("Події")
//                }
//                .tag(0)
//            
//            ExploreView()
//                .tabItem {
//                    Image(systemName: viewModel.selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
//                    Text("Пошук")
//                }
//                .tag(1)
//            
//            ProfileView(viewModel: DIContainer.shared.resolve(ProfileViewModel.self))
//                .tabItem {
//                    Image(systemName: viewModel.selectedTab == 2 ? "person.circle.fill" : "person.circle")
//                    Text("Профіль")
//                }
//                .tag(2)
//        }
//        .accentColor(.purple.opacity(0.8))
//        .loadingOverlay(isLoading: viewModel.isLoading)
//        .errorAlert(error: $viewModel.error)
//        .onAppear {
//            configureTabBarAppearance()
//        }
//    }
//    
//    // MARK: - Private Methods
//    private func configureTabBarAppearance() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.systemBackground
//        
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    let sessionManager = DIContainer.shared.resolve(SessionManager.self)
//    
//    return MainTabView(
//        viewModel: MainTabViewModel(
//            sessionManager: sessionManager,
//            eventsFeedManager: DIContainer.shared.resolve(EventsFeedManager.self)
//        )
//    )
//    .environmentObject(sessionManager)
//}
