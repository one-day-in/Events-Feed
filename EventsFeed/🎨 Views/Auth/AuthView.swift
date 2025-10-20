//// AuthView.swift
//import SwiftUI
//
//struct AuthView: View {
//    @StateObject private var viewModel: AuthViewModel
//    @Environment(\.colorScheme) private var colorScheme
//    
//    init(viewModel: AuthViewModel) {
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    var body: some View {
//        VStack(spacing: 54) {
//            Spacer()
//            headerSection
//            
//            authButtonsSection
//            
//            versionSection
//        }
//        .padding(.horizontal, 32)
//    }
//    
//    private var headerSection: some View {
//        VStack(spacing: 12) {
//            Text("ConcertFlow")
//                .font(.system(size: 42, weight: .bold, design: .rounded))
//                .foregroundStyle(
//                    LinearGradient(
//                        colors: [.blue, .purple],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//            
//            Text("Увійдіть, щоб переглядати концерти та події")
//                .font(.system(size: 18, weight: .light))
//                .foregroundColor(.primary)
//                .multilineTextAlignment(.center)
//        }
//    }
//    
//    private var authButtonsSection: some View {
//        VStack(spacing: 16) {
//            AuthButtonView(
//                provider: .google,
//                isLoading: viewModel.isLoading
//            ) {
//                Task {
//                    await viewModel.signIn(with: .google)
//                }
//            }
//            
//            AuthButtonView(
//                provider: .apple,
//                isLoading: viewModel.isLoading
//            ) {
//                Task {
//                    await viewModel.signIn(with: .apple)
//                }
//            }
//        }
//    }
//    
//    private var versionSection: some View {
//        Text("Версія 1.0.1")
//            .font(.caption)
//            .foregroundColor(.secondary.opacity(0.6))
//    }
//}
//
//#Preview {
//    let authViewModel = DIContainer.shared.resolve(AuthViewModel.self)
//    
//    return AuthView(viewModel: authViewModel)
//}
