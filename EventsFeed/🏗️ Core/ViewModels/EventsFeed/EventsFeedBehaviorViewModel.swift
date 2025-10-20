// Features/EventsFeed/ViewModels/EventsFeedBehaviorViewModel.swift
import Foundation
import SwiftUI

@MainActor
final class EventsFeedBehaviorViewModel: BaseViewModel {
    @Published var scrollState = ScrollState()
    
    // MARK: - Public Methods
    func updateScrollOffset(_ offset: CGFloat) {
        scrollState.updateOffset(offset)
    }
    
    func resetScrollState() {
        scrollState.reset()
    }
}

// MARK: - Scroll State Model
struct ScrollState {
    var currentOffset: CGFloat = 0
    var lastOffset: CGFloat = 0
    var isHeaderVisible: Bool = true
    var hasUserScrolled: Bool = false
    
    mutating func updateOffset(_ offset: CGFloat) {
        let scrollDirection: ScrollDirection = offset > lastOffset ? .up : .down
        
        if hasUserScrolled {
            if scrollDirection == .down && offset < -50 {
                isHeaderVisible = false
            } else if scrollDirection == .up {
                isHeaderVisible = true
            }
        }
        
        if abs(offset - lastOffset) > 2 {
            hasUserScrolled = true
        }
        
        lastOffset = currentOffset
        currentOffset = offset
    }
    
    mutating func reset() {
        currentOffset = 0
        lastOffset = 0
        isHeaderVisible = true
        hasUserScrolled = false
    }
}

// MARK: - Supporting Types
enum ScrollDirection {
    case up, down
}
