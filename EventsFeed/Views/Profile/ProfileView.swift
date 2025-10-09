import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject private var sessionManager: CoordinatedSessionManager
    @StateObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileHeaderView(user: sessionManager.currentUser)
                    UserInfoCardView(user: sessionManager.currentUser)
                    ConnectedServicesView(viewModel: viewModel)
                    AppInfoView(appVersion: viewModel.appVersion)
                    signOutButton
                }
                .padding()
            }
            .navigationTitle("Профіль")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var signOutButton: some View {
        Button(role: .destructive, action: {
            viewModel.handleSignOut()
        }) {
            HStack {
                if viewModel.isSigningOut {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Вийти з акаунту")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(viewModel.isSigningOut)
    }
}

#Preview {
    let sessionManager = DIContainer.shared.resolve(CoordinatedSessionManager.self)
    let profileViewModel = DIContainer.shared.resolve(ProfileViewModel.self)
    
    return ProfileView(viewModel: profileViewModel)
        .environmentObject(sessionManager)
}
