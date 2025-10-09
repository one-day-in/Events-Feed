import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var sessionManager: CoordinatedSessionManager
    @StateObject private var eventsFeedViewModel: EventsFeedViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    
    init() {
        _eventsFeedViewModel = StateObject(wrappedValue: DIContainer.shared.resolve(EventsFeedViewModel.self))
        _profileViewModel = StateObject(wrappedValue: DIContainer.shared.resolve(ProfileViewModel.self))
    }
    
    var body: some View {
        TabView {
            EventsFeedView(viewModel: eventsFeedViewModel)
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Моя підписка")
                }
            
//            ExploreView()
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    Text("Досліджувати")
//                }
            
            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("Профіль")
                }
        }
        .environmentObject(sessionManager)
        .accentColor(.blue)
    }
}

#Preview {
    let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
    
    MainTabView()
        .environmentObject(sessionManager)
}
