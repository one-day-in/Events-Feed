import Foundation

// MARK: - Сервіс управління помилками
final class ErrorService: ObservableObject {
    @Published var currentError: AppError?
    @Published var errorLog: [AppError] = []
    
    private let maxLogSize = 100
    
    static let shared = ErrorService()
    
    private init() {}
    
    // MARK: - Основні методи
    func report(_ error: Error, context: String = "") {
        let appError: AppError
        
        if let authError = error as? AuthError {
            appError = .auth(description: "\(context) \(authError.localizedDescription)")
        } else {
            // Конвертуємо стандартні помилки
            switch error {
            case let urlError as URLError:
                appError = .network(description: "\(context) \(urlError.localizedDescription)")
            default:
                appError = .unknown(description: "\(context) \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.main.async {
            self.currentError = appError
            self.errorLog.append(appError)
            
            // Обмежуємо розмір логу
            if self.errorLog.count > self.maxLogSize {
                self.errorLog.removeFirst()
            }
            
            // Логуємо в консоль
            print("🚨 [ERROR] \(appError.localizedDescription)")
        }
    }
    
    func report(_ appError: AppError) {
        DispatchQueue.main.async {
            self.currentError = appError
            self.errorLog.append(appError)
            print("🚨 [ERROR] \(appError.localizedDescription)")
        }
    }
    
    func clearCurrentError() {
        DispatchQueue.main.async {
            self.currentError = nil
        }
    }
    
    func clearAllErrors() {
        DispatchQueue.main.async {
            self.currentError = nil
            self.errorLog.removeAll()
        }
    }
    
    // MARK: - Спеціалізовані методи
    func reportNetworkError(_ description: String, context: String = "") {
        report(.network(description: "\(context) \(description)"))
    }
    
    func reportAuthError(_ description: String, context: String = "") {
        report(.auth(description: "\(context) \(description)"))
    }
    
    func reportMusicServiceError(_ error: Error, serviceType: MusicServiceType, context: String = "") {
        let appError = error.toAppError(context: context, serviceType: serviceType)
        report(appError)
    }
    
    func reportSpotifyError(_ description: String, context: String = "") {
        report(.musicService(service: .spotify, description: "\(context) \(description)"))
    }
    
    func reportYouTubeMusicError(_ description: String, context: String = "") {
        report(.musicService(service: .youtubeMusic, description: "\(context) \(description)"))
    }
    
    func reportAppleMusicError(_ description: String, context: String = "") {
        report(.musicService(service: .appleMusic, description: "\(context) \(description)"))
    }
    
    func reportDataError(_ description: String, context: String = "") {
        report(.data(description: "\(context) \(description)"))
    }
}

