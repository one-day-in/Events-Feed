import SwiftUI

// MARK: - Основні типи помилок додатка
enum AppError: Error, Identifiable, Equatable {
    case network(description: String)
    case auth(description: String)
    case musicService(service: MusicServiceType, description: String)
    case data(description: String)
    case unknown(description: String)
    
    var id: String { localizedDescription }
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let lhsDesc), .network(let rhsDesc)):
            return lhsDesc == rhsDesc
        case (.auth(let lhsDesc), .auth(let rhsDesc)):
            return lhsDesc == rhsDesc
        case (.musicService(let lhsService, let lhsDesc), .musicService(let rhsService, let rhsDesc)):
            return lhsService == rhsService && lhsDesc == rhsDesc
        case (.data(let lhsDesc), .data(let rhsDesc)):
            return lhsDesc == rhsDesc
        case (.unknown(let lhsDesc), .unknown(let rhsDesc)):
            return lhsDesc == rhsDesc
        default:
            return false
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .network(let description):
            return "Мережева помилка: \(description)"
        case .auth(let description):
            return "Помилка авторизації: \(description)"
        case .musicService(let service, let description):
            return "Помилка \(service.displayName): \(description)"
        case .data(let description):
            return "Помилка даних: \(description)"
        case .unknown(let description):
            return "Неочікувана помилка: \(description)"
        }
    }
    
    var icon: String {
        switch self {
        case .network: return "wifi.exclamationmark"
        case .auth: return "person.crop.circle.badge.exclamationmark"
        case .musicService: return "music.note"
        case .data: return "doc.text.magnifyingglass"
        case .unknown: return "exclamationmark.triangle"
        }
    }
    
    var color: Color {
        switch self {
        case .network: return .orange
        case .auth: return .red
        case .musicService(let service, _):
            switch service {
            case .spotify: return .green
            case .youtubeMusic: return .red
            case .appleMusic: return .pink
            }
        case .data: return .purple
        case .unknown: return .gray
        }
    }
}

// MARK: - Допоміжні методи для конвертації помилок
extension Error {
    func toAppError(context: String = "", serviceType: MusicServiceType? = nil) -> AppError {
        let errorDescription = "\(context) \(self.localizedDescription)".trimmingCharacters(in: .whitespaces)
        
        switch self {
        case _ as URLError:
            return .network(description: errorDescription)
            
        case let authError as AuthError:
            return .auth(description: authError.localizedDescription)
            
        case let musicError as MusicServiceAuthError:
            if let service = serviceType {
                return .musicService(service: service, description: musicError.localizedDescription)
            } else {
                return .unknown(description: errorDescription)
            }
            
        case let appError as AppError:
            return appError
            
        default:
            return .unknown(description: errorDescription)
        }
    }
}
