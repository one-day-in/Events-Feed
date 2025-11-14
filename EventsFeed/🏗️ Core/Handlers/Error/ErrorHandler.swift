import Foundation

@MainActor
final class ErrorHandler: ObservableObject {
    @Published private(set) var currentError: AppError?
    // MARK: - Configuration
    private var errorLog: [AppError] = []
    private let maxErrors = 100
    private let enableDebugLogging: Bool
    
    init(enableDebugLogging: Bool = true) {
        self.enableDebugLogging = enableDebugLogging
    }
    
    // MARK: - Public API
    func handle(_ error: Error, context: String = "", showToUser: Bool = true) {
        let appError = error.toAppError(context: context)
        
        // Показати користувачу (якщо потрібно)
        if showToUser {
            currentError = appError
        }
        
        // Додати до логу
        addToLog(appError)
        
        // Логування для дебагу
        if enableDebugLogging {
            print("🔴 ERROR [\(context)]: \(appError.errorDescription ?? "Unknown")")
        }
    }
    
    func clearCurrent() {
        currentError = nil
    }
    
    func clearAll() {
        currentError = nil
        errorLog.removeAll()
    }
    
    func clearLog() {
        errorLog.removeAll()
    }
    
    func getErrors(ofCategory category: ErrorCategory) -> [AppError] {
        errorLog.filter { $0.category == category }
    }
    
    // MARK: - Private
    private func addToLog(_ error: AppError) {
        errorLog.append(error)
        if errorLog.count > maxErrors {
            errorLog.removeFirst()
        }
    }
}
