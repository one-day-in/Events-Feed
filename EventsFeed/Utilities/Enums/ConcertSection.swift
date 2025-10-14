import Foundation

enum ConcertSection: String, CaseIterable {
    case upcoming = "Найближчі"
    case today = "Сьогодні"
    case past = "Минулі"
    case announs = "Анонси"
    
    var iconName: String {
        switch self {
        case .upcoming: return "calendar"
        case .today: return "sun.max"
        case .past: return "clock.arrow.circlepath"
        case .announs: return "megaphone"
        }
    }
}
