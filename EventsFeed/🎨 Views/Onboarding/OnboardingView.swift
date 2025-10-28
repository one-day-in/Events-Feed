import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    private let onComplete: () -> Void
    @State private var isAuthViewVisible = false
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            SplashView(onSkip: {
                viewModel.skipSplashAnimation()
            })
            
            if viewModel.shouldShowAuthSelection {
                AuthView(
                    onGoogleSignIn: {
                        Task { await viewModel.signInWithGoogle() }
                    },
                    onAppleSignIn: {
                        Task { await viewModel.signInWithApple() }
                    }
                )
                .opacity(isAuthViewVisible ? 1 : 0)
                .scaleEffect(isAuthViewVisible ? 1 : 0.8)
                .offset(y: isAuthViewVisible ? 0 : 50)
                .animation(
                    .spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.5)
                    .delay(0.1),
                    value: isAuthViewVisible
                )
                .onAppear {
                    isAuthViewVisible = true
                }
                .onDisappear {
                    isAuthViewVisible = false
                }
            }
        }
        .onChange(of: viewModel.shouldCompleteOnboarding) { shouldComplete, _ in
            if shouldComplete {
                onComplete()
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
