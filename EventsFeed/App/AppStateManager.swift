// Core/Managers/AppStateManager.swift
import SwiftUI
import Combine

@MainActor
final class AppStateManager: ObservableObject {
    // MARK: - Published Properties
    @Published var appState: AppState = .loading
    @Published var isLoadingAuth: Bool = false
    @Published var isShowingAuthTransition: Bool = false
    @Published var authTransitionState: AuthTransitionState = .hidden
    
    // MARK: - Private Properties
    private var hasStarted = false
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    private let sessionManager: SessionManager
    
    // MARK: - Initialization
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func startAppFlow() {
        guard !hasStarted else { return }
        hasStarted = true
        
        print("🚀 AppStateManager: Запуск додатку")
        
        // Симулюємо завантаження (3 секунди)
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            await MainActor.run {
                withAnimation {
                    self.appState = .ready
                }
                print("✅ AppStateManager: Додаток готовий")
            }
        }
    }
    
    func reset() {
        appState = .loading
        isLoadingAuth = false
        isShowingAuthTransition = false
        authTransitionState = .hidden
        hasStarted = false
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // Слухаємо зміни в sessionManager.isLoading
        sessionManager.$isLoading
            .removeDuplicates()
            .sink { [weak self] isLoading in
                self?.handleAuthLoadingChange(isLoading)
            }
            .store(in: &cancellables)
        
        // Слухаємо зміни в sessionManager.isLoggedIn
        sessionManager.$isLoggedIn
            .removeDuplicates()
            .dropFirst() // Пропускаємо початкове значення
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.handleSuccessfulAuth()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthLoadingChange(_ isLoading: Bool) {
        if isLoading {
            print("🔄 AppStateManager: Початок авторизації")
            withAnimation {
                self.isLoadingAuth = true
            }
        } else {
            print("✅ AppStateManager: Авторизація завершена")
            withAnimation {
                self.isLoadingAuth = false
            }
        }
    }
    
    private func handleSuccessfulAuth() {
        print("🎬 AppStateManager: Успішна авторизація - запуск анімації")
        
        // Запускаємо анімацію переходу
        withAnimation {
            self.isShowingAuthTransition = true
            self.authTransitionState = .animating
        }
        
        // Завершуємо анімацію через 1.2 секунди
        Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            
            await MainActor.run {
                print("✨ AppStateManager: Анімація переходу завершена")
                withAnimation {
                    self.authTransitionState = .completed
                }
            }
            
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            await MainActor.run {
                withAnimation {
                    self.isShowingAuthTransition = false
                    self.authTransitionState = .hidden
                }
            }
        }
    }
}

// MARK: - Supporting Types

enum AppState: Equatable {
    case loading
    case ready
    case error(String)
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.ready, .ready): return true
        case (.error(let lhsError), .error(let rhsError)): return lhsError == rhsError
        default: return false
        }
    }
}

enum AuthTransitionState: Equatable {
    case hidden
    case animating
    case completed
}
