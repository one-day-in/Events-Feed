import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var subscribedConcerts: [Concert] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Stories від улюблених артистів
                if !subscribedConcerts.isEmpty {
                    ArtistStoriesView(concerts: subscribedConcerts)
                        .padding(.bottom, 8)
                }
                
                // Лента концертів
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(subscribedConcerts) { concert in
                            ConcertCard(concert: concert)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await loadSubscriptionsAsync()
                }
            }
            .navigationTitle("Моя підписка")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
            loadSubscriptions()
        }
    }
    
    private func loadSubscriptions() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            loadSubscriptionData()
            isLoading = false
        }
    }
    
    private func loadSubscriptionsAsync() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            loadSubscriptionData()
            isLoading = false
        }
    }
    
    private func loadSubscriptionData() {
        let now = Date()
        let calendar = Calendar.current
        
        subscribedConcerts = [
            Concert(
                title: "Акустичний концерт",
                artist: "Океан Ельзи",
                date: calendar.date(byAdding: .day, value: 3, to: now)!,
                location: "Бесарабський ринок",
                city: "Київ",
                genre: .rock,
                price: 800,
                imageName: "guitars",
                isSaved: true, // Підписаний
                likesCount: 120,
                commentsCount: 34,
                attendeesCount: 200,
                isLiked: true,
                artistID: "9"
            ),
            Concert(
                title: "Rock Night",
                artist: "The Killers",
                date: calendar.date(byAdding: .day, value: 7, to: now)!,
                location: "Палац Спорту",
                city: "Київ",
                genre: .rock,
                price: 1200,
                imageName: "guitars",
                isSaved: true, // Підписаний
                likesCount: 89,
                commentsCount: 23,
                attendeesCount: 1200,
                isLiked: true,
                artistID: "2"
            )
        ]
    }
}

#Preview {
    let authService = GoogleAuthService()
    let sessionManager = SessionManager(authService: authService)
    return FeedView()
        .environmentObject(sessionManager)
}
