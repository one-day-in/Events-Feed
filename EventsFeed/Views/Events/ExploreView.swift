import SwiftUI

struct ExploreView: View {
    @State private var popularConcerts: [Concert] = []
    @State private var searchText = ""
    @State private var selectedSection: ConcertSection = .today
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Пошук артистів, концертів...", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Фільтр за жанром
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ConcertSection.allCases, id: \.self) { section in
                                FilterButton(
                                    title: section.rawValue,
                                    isSelected: selectedSection == section,
                                    action: { selectedSection = section }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 16)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(filteredConcerts) { concert in
                            ConcertCardView(concert: concert)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
        }
    }
    
    private var filteredConcerts: [Concert] {
        var filtered = popularConcerts
        
        // Фільтр за пошуком
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.artist!.localizedCaseInsensitiveContains(searchText) ||
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
}


#Preview {
    ExploreView()
}
