import Foundation
import Combine

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    
    // Використовуємо твій існуючий ErrorService замість локального error
    private let errorService: ErrorService
    
    init(errorService: ErrorService = ErrorService.shared) {
        self.errorService = errorService
    }
    
    // MARK: - Loading State
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    // MARK: - Error Handling через ErrorService
    func handleError(_ error: Error, context: String = "") {
        errorService.report(error, context: "\(String(describing: Self.self)): \(context)")
    }
    
    func handleAppError(_ appError: AppError, context: String = "") {
        errorService.report(appError)
    }
    
    func clearError() {
        errorService.clearCurrentError()
    }
    
    // MARK: - Async Operations
    func performAsyncTask(
        _ task: @escaping () async throws -> Void,
        context: String = ""
    ) async {
        setLoading(true)
        clearError()
        
        do {
            try await task()
        } catch {
            handleError(error, context: context)
        }
        
        setLoading(false)
    }
}
