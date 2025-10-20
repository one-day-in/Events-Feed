// Features/EventsFeed/Managers/EventsFeedManager.swift
import Foundation
import SwiftUI

@MainActor
final class EventsFeedManager: BaseViewModel {
    
    // MARK: - Child ViewModels
    let content: EventsFeedContentViewModel
    let behavior: EventsFeedBehaviorViewModel
    
    // MARK: - Computed Properties
    var hasData: Bool { !content.concerts.isEmpty }
    
    // MARK: - Initialization
    init(
        content: EventsFeedContentViewModel,
        behavior: EventsFeedBehaviorViewModel,
        errorService: ErrorService
    ) {
        self.content = content
        self.behavior = behavior
        super.init(errorService: errorService)
        setupBindings()
    }
    
    // MARK: - Public Methods
    func onAppear() {
        behavior.resetScrollState()
//        loadContentIfNeeded()
    }
    
//    func loadData() async {
//        await content.loadData()
//    }
//    
//    func refreshData() async {
//        await content.refreshData()
//    }
//    
//    func selectSection(_ section: ConcertSection) {
//        content.selectSection(section)
//    }
//    
//    func updateScrollOffset(_ offset: CGFloat) {
//        behavior.updateScrollOffset(offset)
//    }
//    
//    // MARK: - Private Methods
//    private func loadContentIfNeeded() {
//        if content.concerts.isEmpty && !content.isLoading {
//            Task {
//                await content.loadData()
//            }
//        }
//    }
    
    private func setupBindings() {
        content.$isLoading
            .assign(to: &$isLoading)
    }
}
