import SwiftUI

struct ErrorBannerView: View {
    let error: AppError
    let onDismiss: () -> Void
    let dismissButton: String = "xmark.circle.fill"
    
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: error.icon)
                    .font(.title2)
                    .foregroundColor(error.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(error.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Button(action: dismiss) {
                    Image(systemName: dismissButton)
                        .foregroundColor(.white.opacity(0.8))
                        .font(.title2)
                }
            }
            .padding(16)
            .frame(minHeight: 60)
            .background(error.color)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            Spacer()
        }
        .offset(y: isVisible ? 0 : -200)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
            
            // Автоматичне закриття через 8 секунд для нетривіальних помилок
            if error.shouldAutoDismiss {
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    dismiss()
                }
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isVisible = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

extension AppError {
    var icon: String {
        switch self {
        case .network:
            return "wifi.exclamationmark"
        case .auth:
            return "person.crop.circle.badge.exclamationmark"
        case .api:
            return "server.rack"
        case .system:
            return "gear.badge.exclamationmark"
        case .unknown:
            return "exclamationmark.triangle"
        }
    }
    
    var color: Color {
        switch self {
        case .network:
            return .orange
        case .auth:
            return .red
        case .api:
            return .purple
        case .system:
            return .blue
        case .unknown:
            return .gray
        }
    }
    
    var title: String {
        switch self {
        case .network:
            return "Мережева помилка"
        case .auth:
            return "Помилка авторизації"
        case .api:
            return "Помилка сервера"
        case .system:
            return "Системна помилка"
        case .unknown:
            return "Неочікувана помилка"
        }
    }
    
    var shouldAutoDismiss: Bool {
        switch self {
        case .network(let networkCase):
            switch networkCase {
            case .cancelled:
                return true // Не потрібно показувати довго
            default:
                return false
            }
        case .auth(let authCase):
            switch authCase {
            case .cancelled:
                return true
            default:
                return false
            }
        case .api(let apiCase):
            switch apiCase {
            case .httpError(let statusCode, _):
                return (400...499).contains(statusCode) // Client errors - shorter display
            default:
                return false
            }
        case .system:
            return false // System errors should stay visible
        case .unknown:
            return false
        }
    }
    
    // Додаткова інформація для дебагу
    var debugInfo: String {
        switch self {
        case .network(let networkCase):
            return "Network case: \(networkCase)"
        case .auth(let authCase):
            return "Auth case: \(authCase)"
        case .api(let apiCase):
            return "API case: \(apiCase)"
        case .system(let systemCase):
            return "System case: \(systemCase)"
        case .unknown(let description):
            return "Unknown: \(description)"
        }
    }
}

// Додатковий модифікатор для зручного відображення помилок
extension View {
    func errorBanner(isPresented: Binding<Bool>, error: AppError?, onDismiss: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue, let error = error {
                ErrorBannerView(error: error, onDismiss: {
                    onDismiss()
                    isPresented.wrappedValue = false
                })
            }
        }
    }
}
