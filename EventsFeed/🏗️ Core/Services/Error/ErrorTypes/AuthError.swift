import AuthenticationServices

enum AuthError: Error, LocalizedError {
    case noRootViewController
    case userNotFound
    case tokenRefreshFailed
    case unsupportedProvider
    
    var errorDescription: String? {
        switch self {
        case .noRootViewController:
            return "Не вдалося знайти вікно для авторизації"
        case .userNotFound:
            return "Користувача не знайдено"
        case .tokenRefreshFailed:
            return "Не вдалося оновити токен доступу"
        case .unsupportedProvider:
            return "Непідтримуваний метод входу"
        }
    }
}
