import SwiftUI

struct MainTabView: View {
    @StateObject private var manager: EventsFeedManager
    @StateObject private var sessionManager: SessionManager
    
    @State private var selectedTab = 0
    
    init() {
            _manager = StateObject(wrappedValue: DIContainer.shared.resolve(EventsFeedManager.self))
            _sessionManager = StateObject(wrappedValue: DIContainer.shared.resolve(SessionManager.self))
        }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsFeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "music.note.square.stack.fill" : "music.note.square.stack")
                    Text("Події")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                    Text("Пошук")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.circle.fill" : "person.circle")
                    Text("Профіль")
                }
                .tag(2)
        }
        .environmentObject(manager)
        .environmentObject(sessionManager)
        .accentColor(.purple.opacity(0.8))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    return MainTabView()
        
}
