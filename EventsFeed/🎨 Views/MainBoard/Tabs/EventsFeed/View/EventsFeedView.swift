//// Features/EventsFeed/Views/EventsFeedView.swift
//import SwiftUI
//
//struct EventsFeedView: View {
//    @StateObject var viewModel: EventsFeedManager
//    
//    var body: some View {
//        NavigationView {
//            ScrollViewReader { proxy in
//                ScrollView {
//                    VStack(spacing: 0) {
//                        headerSection
//                        contentSection
//                    }
//                    .background(
//                        GeometryReader { geometry in
//                            Color.clear
//                                .onAppear {
//                                    viewModel.updateScrollOffset(geometry.frame(in: .global).minY)
//                                }
//                                .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
//                                    viewModel.updateScrollOffset(newValue)
//                                }
//                        }
//                    )
//                }
//            }
//            .navigationTitle("Концерти")
//            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    refreshButton
//                }
//            }
//            .refreshable {
//                await viewModel.refreshData()
//            }
//            .loadingOverlay(isLoading: viewModel.isLoading && viewModel.content.concerts.isEmpty)
//            .errorAlert(error: $viewModel.currentError)
//        }
//        .onAppear {
//            viewModel.onAppear()
//        }
//    }
//    
//    // MARK: - Subviews
//    private var headerSection: some View {
//        VStack(spacing: 16) {
//           
//            sectionsPicker
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.behavior.scrollState.isHeaderVisible)
//    }
//
//    
//    private var contentSection: some View {
//        LazyVStack(spacing: 12) {
//            if viewModel.isLoading && viewModel.content.concerts.isEmpty {
//                loadingView
//            } else if viewModel.content.filteredConcerts.isEmpty {
//                emptyStateView
//            } else {
//                ForEach(viewModel.content.filteredConcerts) { concert in
//                    ConcertCardView(concert: concert)
//                        .padding(.horizontal)
//                }
//            }
//        }
//        .padding(.vertical)
//    }
//    
//    private var refreshButton: some View {
//        Button {
//            Task {
//                await viewModel.refreshData()
//            }
//        } label: {
//            Image(systemName: "arrow.clockwise")
//                .font(.system(size: 18, weight: .medium))
//        }
//        .disabled(viewModel.isLoading)
//    }
//    
//    private var loadingView: some View {
//        VStack(spacing: 16) {
//            ProgressView()
//                .scaleEffect(1.2)
//            Text("Завантаження концертів...")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//        }
//        .frame(height: 200)
//    }
//    
//    private var emptyStateView: some View {
//        VStack(spacing: 16) {
//            Image(systemName: "music.note.list")
//                .font(.system(size: 64))
//                .foregroundColor(.secondary)
//            
//            Text("Концерти не знайдено")
//                .font(.headline)
//                .foregroundColor(.primary)
//            
//            Text("Спробуйте вибрати іншу категорію")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//        }
//        .frame(height: 300)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    EventsFeedView(
//        viewModel: DIContainer.shared.resolve(EventsFeedManager.self)
//    )
//}
