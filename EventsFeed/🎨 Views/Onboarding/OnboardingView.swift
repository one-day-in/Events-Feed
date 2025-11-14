import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {            
            SplashView(onComplete: {
                viewModel.handleSplashCompletion()
            })
            .opacity((viewModel.shouldShowAuthButtons ? 0.65 : 1.0))
            .blur(radius: viewModel.shouldShowAuthButtons ? 2 : 0)
            .brightness(viewModel.shouldShowAuthButtons ? -0.1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.shouldShowAuthButtons)
            
            if viewModel.shouldShowAuthButtons && !viewModel.isUserAuthenticated {
                AuthView(
                    onGoogleSignIn: {
                        Task { await viewModel.signInWithGoogle() }
                    },
                    onAppleSignIn: {
                        Task { await viewModel.signInWithApple() }
                    }
                )
                .transition(.asymmetric(
                    insertion: .opacity
                        .combined(with: .scale(scale: 0.8, anchor: .center))
                        .combined(with: .offset(y: 50))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)),
                    removal: .opacity
                        .combined(with: .scale(scale: 0.9))
                        .animation(.easeOut(duration: 0.4))
                ))
            }
        }
        .onAppear(perform: viewModel.checkAuthentication)
        .onChange(of: viewModel.shouldProceedToMain) {
            if viewModel.shouldProceedToMain {
                withAnimation(.easeInOut(duration: 0.6)) {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    let container = DIContainer()
    let viewModel = ViewModelFactory(container: container).makeOnboardingViewModel()
    
    OnboardingView(
        onComplete: {
            print("Onboarding completed!")
        }
    )
    .environmentObject(viewModel)
}
