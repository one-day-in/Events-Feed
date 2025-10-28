//// Features/Profile/Views/ProfileView.swift
//import SwiftUI
//
//struct ProfileView: View {
//    @StateObject var viewModel: AppStateManager
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Заголовок профілю
////                    ProfileHeaderView(user: viewModel.user)
//                    
//                    // Інформація про акаунт
////                    UserInfoCardView(user: viewModel.user)
//                    
//                    // Підключені сервіси
//                    ConnectedServicesView(viewModel: viewModel)
//                    
//                    // Інформація про додаток
//                    AppInfoView(appVersion: viewModel.appVersion)
//                    
//                    // Кнопка виходу
//                    if viewModel.isLoggedIn {
//                        SignOutButton {
//                            Task {
//                                await viewModel.signOut()
//                            }
//                        }
//                        .disabled(viewModel.isLoading)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Профіль")
//            .background(Color(.systemGroupedBackground))
//            .loadingOverlay(isLoading: viewModel.isLoading)
//            .errorAlert(error: $viewModel.error)
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    ProfileView()
//        .environmentObject(DIContainer.shared.resolve(AppStateManager.self))
//}
