import Foundation

actor CoreErrorService {
    private var errors: [AppError] = []
    private let maxErrors = 100
    
    // MARK: - Логування
    func log(_ error: Error, context: String = "") {
        let appError = error.toAppError(context: context)
        errors.append(appError)
        if errors.count > maxErrors { errors.removeFirst() }
        
        // Місце для бекенд логування, Crashlytics, аналітики тощо
    }
    
    // MARK: - Читання
    func getAllErrors() -> [AppError] {
        errors
    }
    
    // MARK: - Очищення
    func clear() {
        errors.removeAll()
    }
    
    func clear(ofType type: ErrorType) {
        errors.removeAll { error in
            switch (type, error) {
            case (.auth, .auth), (.network, .network),
                 (.music, .music), (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
    }
}
