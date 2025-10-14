import SwiftUI

struct ProfileView: View {
    @StateObject private var sessionManager: SessionManager
    
    init() {
        _sessionManager = StateObject(wrappedValue: DIContainer.shared.resolve(SessionManager.self))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок профілю
                    ProfileHeaderView(user: sessionManager.currentUser)
                    
                    // Інформація про акаунт
                    UserInfoCardView(user: sessionManager.currentUser)
                    
                    // Підключені сервіси
                    ConnectedServicesView(sessionManager: sessionManager)
                    
                    // Інформація про додаток
                    AppInfoView(appVersion: getAppVersion())
                    
                    // Кнопка виходу
                    SignOutButton {
                        sessionManager.signOut()
                    }
                }
                .padding()
            }
            .navigationTitle("Профіль")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func getAppVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}

#Preview {
    ProfileView()
}
