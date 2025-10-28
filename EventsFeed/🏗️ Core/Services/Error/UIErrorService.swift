import Foundation

enum ErrorType: String {
    case auth, network, music, unknown
}

@MainActor
final class UIErrorService: ObservableObject {
    @Published private(set) var currentError: AppError?
    @Published private(set) var errorLog: [AppError] = []
    
    private let coreService: CoreErrorService
    
    init(coreService: CoreErrorService) {
        self.coreService = coreService
    }
    
    // MARK: - Логування та показ UI
    func report(_ error: Error, context: String = "") {
        let appError = error.toAppError(context: context)
        currentError = appError
        errorLog.append(appError)
        if errorLog.count > 100 { errorLog.removeFirst() }
        
        Task {
            await coreService.log(error, context: context)
        }
    }
    
    // MARK: - Очищення
    func clearError() {
        currentError = nil
    }
    
    func clearAll() {
        currentError = nil
        errorLog.removeAll()
        
        Task {
            await coreService.clear()
        }
    }
    
    func clearError(ofType type: ErrorType) {
        if matches(type, currentError) {
            currentError = nil
        }
        errorLog.removeAll { matches(type, $0) }
        
        // Просто передаємо рядок, без прив'язки до конкретного enum
        Task {
            await coreService.clear(ofType: type)
        }
    }
    
    // MARK: - Приватна логіка відповідності типів
    private func matches(_ type: ErrorType, _ error: AppError?) -> Bool {
        guard let error = error else { return false }
        switch (type, error) {
        case (.auth, .auth),
             (.network, .network),
             (.music, .music),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
