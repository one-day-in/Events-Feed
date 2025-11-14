// MainBoardView.swift
import SwiftUI

struct MainBoardView: View {
    private let tabCoordinator: MainBoardCoordinator
    
    init(tabCoordinator: MainBoardCoordinator) {
        self.tabCoordinator = tabCoordinator
    }
    
    var body: some View {
        TabView {
            // Головна сторінка
            tabCoordinator.makeHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Головна")
                }
            
            // Навігація/Досліджувати
            tabCoordinator.makeExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Досліджувати")
                }
            
            // Профіль
            tabCoordinator.makeProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профіль")
                }
        }
        .accentColor(.primary)
    }
}

#Preview {
    let container = DIContainer()
    let viewModelFactory = ViewModelFactory(container: container)
    
    // Створюємо MainTabCoordinator для Preview
    let tabCoordinator = MainBoardCoordinator(
        viewModelFactory: viewModelFactory,
        onLogout: {
            print("User logged out from Preview")
        }
    )
    
    return MainBoardView(tabCoordinator: tabCoordinator)
}
