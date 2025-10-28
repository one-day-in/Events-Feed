// AppError.swift
import SwiftUI

enum AppError: Error, LocalizedError, Identifiable, Equatable {
    case network(String)
    case auth(String)
    case music(String)
    case unknown(String)
    
    var id: String { errorDescription ?? "Unknown" }
    
    var errorDescription: String? {
        switch self {
        case .network(let msg):
            return "Мережева помилка: \(msg)"
        case .auth(let msg):
            return "Помилка авторизації: \(msg)"
        case .music(let msg):
            return "Помилка музичного сервісу: \(msg)"
        case .unknown(let msg):
            return "Неочікувана помилка: \(msg)"
        }
    }
}

extension Error {
    func toAppError(context: String = "") -> AppError {
        let message = [context, localizedDescription]
            .filter { !$0.isEmpty }
            .joined(separator: " — ")
        
        switch self {
        case _ as URLError:
            return .network(message)
        case let authError as AuthError:
            return .auth(authError.localizedDescription)
        case let musicError as MusicServiceAuthError:
            // Класифікуємо помилки MusicServiceAuthError
            switch musicError {
            case .accessDenied, .tokenExpired, .tokenRefreshFailed:
                return .auth(message)  // Помилки авторизації/доступу
            case .invalidAuthURL, .noCallbackData, .noAccessToken,
                    .tokenExchangeFailed, .serviceError, .notImplemented:
                return .music(message)  // Технічні помилки музичного сервісу
            }
        case let appError as AppError:
            return appError
        default:
            return .unknown(message)
        }
    }
}
