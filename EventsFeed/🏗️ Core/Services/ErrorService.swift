import Foundation

final class ErrorService: ObservableObject {
    // MARK: - Published State
    @Published @MainActor var currentError: AppError?
    @Published @MainActor var errorLog: [AppError] = []
    
    private let maxLogSize = 100
    static let shared = ErrorService()
    private init() {}
    
    // MARK: - Основний метод уніфікованого репортингу
    func report(
        _ error: Error,
        context: String = "",
        serviceType: MusicServiceType? = nil
    ) {
        let appError = error.toAppError(context: context, serviceType: serviceType)
        report(appError)
    }
    
    // MARK: - Пряма публікація AppError
    func report(_ appError: AppError) {
        Task { @MainActor in
            self.currentError = appError
            self.errorLog.append(appError)
            
            if self.errorLog.count > self.maxLogSize {
                self.errorLog.removeFirst()
            }
            
            print("🚨 [ERROR] \(appError.localizedDescription)")
        }
    }
    
    // MARK: - Очистка
    func clearCurrentError() {
        Task { @MainActor in
            self.currentError = nil
        }
    }
    
    func clearAllErrors() {
        Task { @MainActor in
            self.currentError = nil
            self.errorLog.removeAll()
        }
    }
    
    // MARK: - Додаткові шорткати
    func reportNetwork(_ description: String, context: String = "") {
        report(.network(description: "\(context) \(description)"))
    }
    
    func reportAuth(_ description: String, context: String = "") {
        report(.auth(description: "\(context) \(description)"))
    }
    
    func reportMusicService(
        _ error: Error,
        serviceType: MusicServiceType,
        context: String = ""
    ) {
        let appError = error.toAppError(context: context, serviceType: serviceType)
        report(appError)
    }
}
