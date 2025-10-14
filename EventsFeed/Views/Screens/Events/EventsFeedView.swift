import SwiftUI

struct EventsFeedView: View {
    @EnvironmentObject private var manager: EventsFeedManager
        
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        Color.clear
                            .frame(height: 1)
                            .background(GeometryReader { geo in
                                Color.clear
                                    .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                        manager.behavior.updateScrollOffset(newValue)
                                    }
                            })
                        
                        if manager.content.isLoadingData {
                            ForEach(0..<5, id: \.self) { _ in
                                ConcertCardPlaceholderView()
                            }
                        } else {
                            ForEach(manager.content.filteredConcerts) { concert in
                                ConcertCardView(concert: concert)
                            }
                        }
                    }
                    .padding(.top, 60)
                }
                .refreshable {
                    // await manager.content.refreshConcerts()
                }
                
                EventsFeedHeaderView()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .offset(y: manager.behavior.scrollState.isHeaderVisible ? 0 : -60)
                    .shadow(
                        color: .black.opacity(
                            manager.behavior.scrollState.hasUserScrolled &&
                            manager.behavior.scrollState.currentOffset < -10 ? 0.3 : 0
                        ),
                        radius: 5, x: 0, y: 2
                    )
                    .animation(
                        .spring(response: 0.4, dampingFraction: 1.8),
                        value: manager.behavior.scrollState.isHeaderVisible
                    )
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            manager.onAppear()
        }
    }
}

#Preview {
    let manager = DIContainer.shared.resolve(EventsFeedManager.self)
    
    return EventsFeedView()
        .environmentObject(manager)
}

#Preview("Loading State") {
    let manager = DIContainer.shared.resolve(EventsFeedManager.self)
    manager.content.isLoadingData = true
    
    return EventsFeedView()
        .environmentObject(manager)
}
