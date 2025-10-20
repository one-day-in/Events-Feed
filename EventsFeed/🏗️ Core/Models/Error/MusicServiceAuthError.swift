import Foundation

enum MusicServiceAuthError: Error, LocalizedError {
    // Основні помилки авторизації
    case failedToGetBundleID
    case invalidAuthURL
    case noCallbackData
    case noAccessToken
    case tokenExchangeFailed
    case failedToStartSession
    case serviceError(String)
    case notImplemented
    
    // Специфічні для Apple Music
    case noSubscription
    case accessDenied
    case notDetermined
    case restricted
    
    var errorDescription: String? {
        switch self {
        case .failedToGetBundleID:
            return "Не вдалося отримати Bundle ID"
        case .invalidAuthURL:
            return "Невірний URL автентифікації"
        case .noCallbackData:
            return "Не отримано дані зворотного виклику"
        case .noAccessToken:
            return "Токен доступу не отримано"
        case .tokenExchangeFailed:
            return "Помилка обміну токенів"
        case .failedToStartSession:
            return "Не вдалося запустити сесію автентифікації"
        case .serviceError(let message):
            return message
        case .notImplemented:
            return "Функціонал не реалізовано"
        case .noSubscription:
            return "Потрібна активна підписка Apple Music"
        case .accessDenied:
            return "Доступ заборонено"
        case .notDetermined:
            return "Статус авторизації не визначено"
        case .restricted:
            return "Доступ обмежено"
        }
    }
}
