import SwiftUI

struct MainBoardView: View {
    @EnvironmentObject private var viewModel: MainBoardViewModel
    private let onLogout: () -> Void
    
    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Music Services")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button("Sign Out") {
                    viewModel.signOut()
                    onLogout()
                }
                .foregroundColor(.red)
            }
            .padding()
        }
    }
}

#Preview {
    let container = DIContainer()
    let viewModel = MainBoardViewModel(
        authManager: container.resolve(AuthManager.self),
        musicServiceManager: container.resolve(MusicServiceManager.self),
        errorService: container.resolve(UIErrorService.self),
        loadingService: container.resolve(LoadingService.self)
    )
    
    return MainBoardView(onLogout: {
        print("User logged out")
    })
    .environmentObject(viewModel)
}
