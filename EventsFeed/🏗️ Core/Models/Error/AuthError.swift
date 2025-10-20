//import SwiftUI
import AuthenticationServices

// MARK: - Загальні помилки авторизації
// AuthError.swift
enum AuthError: Error, LocalizedError {
    case noRootViewController
    case signInCancelled
    case signInFailed(Error)
    
    // Apple Sign-In errors
    case appleSignInFailed
    case invalidState
    case tokenNotFound
    case appleSignInFailedWithError(Error)
    
    // Common errors
    case userNotFound
    case sessionExpired
    case invalidCredentials
    case unsupportedProvider  // ← ДОДАТИ ЦЕЙ КЕЙС
    
    var errorDescription: String? {
        switch self {
        case .noRootViewController:
            return "Не вдалося отримати кореневий контролер"
        case .signInCancelled:
            return "Авторизацію скасовано"
        case .signInFailed(let error):
            return "Помилка авторизації: \(error.localizedDescription)"
            
        // Apple Sign-In
        case .appleSignInFailed:
            return "Помилка Apple авторизації"
        case .invalidState:
            return "Недійсний стан під час Apple авторизації"
        case .tokenNotFound:
            return "Токен Apple ID не знайдено"
        case .appleSignInFailedWithError(let error):
            return "Помилка Apple авторизації: \(error.localizedDescription)"
            
        // Common
        case .userNotFound:
            return "Користувача не знайдено"
        case .sessionExpired:
            return "Сесія закінчилася. Увійдіть знову"
        case .invalidCredentials:
            return "Невірні облікові дані"
        case .unsupportedProvider:  // ← ДОДАТИ ОПИС
            return "Непідтримуваний провайдер авторизації"
        }
    }
    
    var icon: String {
        switch self {
        case .noRootViewController, .invalidState:
            return "uiwindow.split.2x1"
        case .signInCancelled:
            return "xmark.circle"
        case .signInFailed, .appleSignInFailed, .appleSignInFailedWithError:
            return "person.crop.circle.badge.exclamationmark"
        case .tokenNotFound:
            return "key"
        case .userNotFound:
            return "person.crop.circle.badge.questionmark"
        case .sessionExpired:
            return "clock.badge.exclamationmark"
        case .invalidCredentials:
            return "person.badge.key"
        case .unsupportedProvider:  // ← ДОДАТИ ІКОНКУ
            return "person.crop.circle.badge.xmark"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noRootViewController:
            return "Спробуйте перезапустити додаток"
        case .signInCancelled, .appleSignInFailed:
            return "Спробуйте авторизуватися знову"
        case .sessionExpired:
            return "Будь ласка, увійдіть у свій обліковий запис знову"
        case .invalidCredentials:
            return "Перевірте правильність введених даних"
        case .userNotFound:
            return "Перевірте, чи існує обліковий запис"
        case .unsupportedProvider:  // ← ДОДАТИ РЕКОМЕНДАЦІЮ
            return "Оберіть інший спосіб авторизації"
        default:
            return "Спробуйте пізніше або зверніться до служби підтримки"
        }
    }
}

// MARK: - Допоміжні методи для конвертації помилок
extension Error {
    func toAuthError() -> AuthError {
        switch self {
        case let authError as AuthError:
            return authError
            
        case let nsError as NSError where nsError.domain == "com.google.GIDSignIn":
            if nsError.code == -5 {
                return .signInCancelled
            } else {
                return .signInFailed(self)
            }
            
        case let asError as ASAuthorizationError:
            switch asError.code {
            case .canceled:
                return .signInCancelled
            default:
                // Всі інші помилки ASAuthorizationError обробляємо однаково
                return .appleSignInFailedWithError(asError)
            }
            
        default:
            return .signInFailed(self)
        }
    }
}
