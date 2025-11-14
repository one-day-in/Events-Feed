// AppError.swift
import SwiftUI
import AuthenticationServices

enum AppError: Error, LocalizedError, Identifiable, Equatable {
    // 🔄 ОБ'ЄДНУЄМО однотипні помилки
    case network(NetworkErrorCase)
    case auth(AuthErrorCase)
    case api(ApiErrorCase)
    case system(SystemErrorCase)
    case unknown(description: String)
    
    // 🌐 Мережеві помилки (URLError + мережеві)
    enum NetworkErrorCase: Equatable {
        case notConnected
        case timedOut
        case cannotConnectToHost
        case dnsLookupFailed
        case badURL
        case cancelled
        case custom(URLError)
    }
    
    // 🔐 Помилки авторизації
    enum AuthErrorCase: Equatable {
        // Загальні
        case cancelled
        case accessDenied
        case tokenExpired
        case tokenRefreshFailed
        case unsupportedProvider
        
        // Специфічні для провайдерів
        case userNotFound
        case invalidToken
        
        // Сервіси
        case serviceUnavailable
        case serviceError(String)
    }
    
    // 📡 API помилки (HTTP + обробка даних)
    enum ApiErrorCase: Equatable {
        case invalidURL
        case invalidResponse
        case httpError(statusCode: Int, message: String)
        case decodingFailed(String)
        case requestFailed(String)
    }
    
    // 💻 Системні помилки
    enum SystemErrorCase: Equatable {
        case noRootViewController
        case presentationContextInvalid
        case notImplemented
        case invalidConfiguration
    }
    
    var id: String { errorDescription ?? "unknown" }
    
    var errorDescription: String? {
        switch self {
        case .network(let networkCase):
            return networkDescription(for: networkCase)
        case .auth(let authCase):
            return authDescription(for: authCase)
        case .api(let apiCase):
            return apiDescription(for: apiCase)
        case .system(let systemCase):
            return systemDescription(for: systemCase)
        case .unknown(let description):
            return "Неочікувана помилка: \(description)"
        }
    }
    
    // 🔧 Допоміжні властивості для обробки
    var category: ErrorCategory {
        switch self {
        case .network: return .network
        case .auth: return .auth
        case .api: return .api
        case .system: return .unknown
        case .unknown: return .unknown
        }
    }
    
    var canRetry: Bool {
        switch self {
        case .network(let networkCase):
            switch networkCase {
            case .notConnected, .timedOut, .cannotConnectToHost:
                return true
            default:
                return false
            }
        case .api(let apiCase):
            switch apiCase {
            case .httpError(let statusCode, _):
                return (500...599).contains(statusCode) // Retry server errors
            default:
                return false
            }
        default:
            return false
        }
    }
}

// MARK: - Опис помилок
extension AppError {
    private func networkDescription(for networkCase: NetworkErrorCase) -> String {
        switch networkCase {
        case .notConnected: return "Відсутнє інтернет-з'єднання"
        case .timedOut: return "Час очікування вийшов"
        case .cannotConnectToHost: return "Не вдається підключитися до сервера"
        case .dnsLookupFailed: return "Помилка пошуку сервера"
        case .badURL: return "Невірна адреса"
        case .cancelled: return "Запит скасовано"
        case .custom(let error): return "Мережева помилка: \(error.localizedDescription)"
        }
    }
    
    private func authDescription(for authCase: AuthErrorCase) -> String {
        switch authCase {
        case .cancelled: return "Авторизацію скасовано"
        case .accessDenied: return "Доступ заборонено"
        case .tokenExpired: return "Термін дії токену закінчився"
        case .tokenRefreshFailed: return "Не вдалося оновити токен"
        case .unsupportedProvider: return "Непідтримуваний метод входу"
        case .userNotFound: return "Користувача не знайдено"
        case .invalidToken: return "Недійсний токен"
        case .serviceUnavailable: return "Сервіс тимчасово недоступний"
        case .serviceError(let message): return "Помилка сервісу: \(message)"
        }
    }
    
    private func apiDescription(for apiCase: ApiErrorCase) -> String {
        switch apiCase {
        case.invalidURL: return "Невірна адреса запиту"
        case .invalidResponse: return "Невірна відповідь від сервера"
        case .httpError(let statusCode, let message): return "Помилка \(statusCode): \(message)"
        case .decodingFailed(let errorMessage): return "Помилка обробки отриманих даних: \(errorMessage)"
        case .requestFailed(let description): return "Помилка запиту до API серверу: \(description)"
        }
    }
    
    private func systemDescription(for systemCase: SystemErrorCase) -> String {
        switch systemCase {
        case .noRootViewController: return "Не вдалося знайти вікно для авторизації"
        case .presentationContextInvalid: return "Помилка відображення вікна авторизації"
        case .notImplemented: return "Функціонал не реалізовано"
        case .invalidConfiguration: return "Невірна конфігурація додатку"
        }
    }
}

// MARK: - Конвертація
extension Error {
    func toAppError(context: String = "") -> AppError {
        let message = [context, localizedDescription]
            .filter { !$0.isEmpty }
            .joined(separator: " — ")
        
        switch self {
        case let urlError as URLError:
            return .network(urlError.toNetworkErrorCase())
            
        case let asError as ASWebAuthenticationSessionError:
            switch asError.code {
            case .canceledLogin: return .auth(.cancelled)
            case .presentationContextNotProvided, .presentationContextInvalid:
                return .system(.presentationContextInvalid)
            @unknown default: return .unknown(description: "Помилка системної авторизації")
            }
            
        case let appError as AppError:
            return appError
            
        default:
            return .unknown(description: message)
        }
    }
}

extension URLError {
    func toNetworkErrorCase() -> AppError.NetworkErrorCase {
        switch self.code {
        case .notConnectedToInternet, .networkConnectionLost: return .notConnected
        case .timedOut: return .timedOut
        case .cannotConnectToHost: return .cannotConnectToHost
        case .cannotFindHost, .dnsLookupFailed: return .dnsLookupFailed
        case .badURL: return .badURL
        case .cancelled: return .cancelled
        default: return .custom(self)
        }
    }
}

// MARK: - Категорії для аналітики/логів
enum ErrorCategory: String, CaseIterable {
    case network
    case auth
    case api
    case system
    case unknown
}
