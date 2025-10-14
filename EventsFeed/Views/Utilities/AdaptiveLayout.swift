import SwiftUI

struct AdaptiveLayout {
    static func scaledSize(for size: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
//        let baseWidth: CGFloat = 375 // iPhone SE width
        
        if screenWidth <= 375 { // Small phones
            return size * 0.9
        } else if screenWidth <= 414 { // Medium phones
            return size
        } else { // Large phones
            return size * 1.1
        }
    }
    
    static var cardCornerRadius: CGFloat {
        scaledSize(for: 16)
    }
    
    static var cardPadding: CGFloat {
        scaledSize(for: 16)
    }
}
