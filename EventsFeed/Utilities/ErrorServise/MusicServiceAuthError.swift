import SwiftUI

// MARK: - Помилки музичних сервісів (уніфіковані)
enum MusicServiceAuthError: Error, LocalizedError {
    case failedToGetBundleID
    case invalidAuthURL
    case noCallbackData
    case noAccessToken
    case tokenExchangeFailed
    case failedToStartSession
    case serviceError(String)
    case notImplemented
    case invalidRedirectURI
    case clientSecretRequired
    
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
        case .invalidRedirectURI:
            return "Невірний redirect URI"
        case .clientSecretRequired:
            return "Client secret обов'язковий для цього сервісу"
        }
    }
}
