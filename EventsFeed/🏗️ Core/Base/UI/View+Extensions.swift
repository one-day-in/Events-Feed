// View+Extensions.swift
import SwiftUI

extension View {
    /// Спрощена обробка стану завантаження
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.regularMaterial)
                                .shadow(color: .black.opacity(0.1), radius: 10)
                        )
                }
            }
        }
    }
    
    /// Global error alert через ErrorService
    func globalErrorAlert(errorService: ErrorService) -> some View {
        self.alert(
            "Помилка",
            isPresented: .constant(errorService.currentError != nil),
            presenting: errorService.currentError
        ) { _ in
            Button("OK") {
                errorService.clearCurrentError()
            }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    /// Apply loading and global error handling
    func withGlobalHandlers(
        isLoading: Bool,
        errorService: ErrorService
    ) -> some View {
        self
            .loadingOverlay(isLoading: isLoading)
            .globalErrorAlert(errorService: errorService)
    }
}
