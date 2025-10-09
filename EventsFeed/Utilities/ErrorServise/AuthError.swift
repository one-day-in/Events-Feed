import SwiftUI

// MARK: - Помилки Google авторизації
enum AuthError: Error, LocalizedError {
    case noRootViewController
    case signInCancelled
    case signInFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .noRootViewController:
            return "Не вдалося отримати кореневий контролер"
        case .signInCancelled:
            return "Авторизацію скасовано"
        case .signInFailed(let error):
            return "Помилка авторизації: \(error.localizedDescription)"
        }
    }
}

