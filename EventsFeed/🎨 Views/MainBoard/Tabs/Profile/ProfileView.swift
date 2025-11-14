import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    profileSection
                    musicServicesSection
                    appSettingsSection
                    accountStatusSection
                    infoSection
                    logoutSection
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EmptyView()) {
                            Text("Edit")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Sections
private extension ProfileView {
    var profileSection: some View {
        ProfileHeaderView(user: viewModel.user)
    }
    
    var accountStatusSection: some View {
        AccountStatusSectionView()
    }
    
    var musicServicesSection: some View {
        MusicServicesSectionView(viewModel: viewModel)
    }
    
    var appSettingsSection: some View {
        AppSettingsSectionView()
    }
    
    var infoSection: some View {
        InfoSectionView(viewModel: viewModel)
    }
    
    var logoutSection: some View {
        LogoutSectionView(viewModel: viewModel)
    }
}

#Preview {
    let container = DIContainer()
    let viewModelFactory = ViewModelFactory(container: container)
    let profileViewModel = viewModelFactory.makeProfileViewModel {}
    
    return ProfileView(viewModel: profileViewModel)
}
