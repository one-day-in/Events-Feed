import Foundation

enum MusicServiceAuthError: Error, LocalizedError {
    
    // MARK: - Загальні помилки авторизації
    case accessDenied
    case tokenExpired
    case tokenRefreshFailed
    case serviceError(String)
    case notImplemented 
    
    // MARK: - Специфічні помилки сервісів
    case invalidAuthURL
    case noCallbackData
    case noAccessToken
    case tokenExchangeFailed
    
    // MARK: - LocalizedError
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Доступ заборонено"
        case .tokenExpired:
            return "Термін дії токену закінчився"
        case .tokenRefreshFailed:
            return "Не вдалося оновити токен"
        case .serviceError(let message):
            return "Помилка сервісу: \(message)"
        case .notImplemented:  // ✅ Додаємо опис
            return "Функціонал не реалізовано для цього сервісу"
        case .invalidAuthURL:
            return "Невірний URL для авторизації"
        case .noCallbackData:
            return "Не отримано дані після авторизації"
        case .noAccessToken:
            return "Токен доступу не отримано"
        case .tokenExchangeFailed:
            return "Помилка при обміні коду на токен"
        }
    }
}
