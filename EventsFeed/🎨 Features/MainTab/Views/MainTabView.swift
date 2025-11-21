import SwiftUI

struct MainTabView: View {

    let home: HomeView
    let explore: ExploreView
    let profile: ProfileView

    var body: some View {
        TabView {
            home
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            explore
                            .tabItem {
                                Label("Explore", systemImage: "safari")
                            }

            profile
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}


