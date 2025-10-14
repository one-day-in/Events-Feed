import SwiftUI

struct AuthButtonView: View {
    let provider: AuthProvider
    let isLoading: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .tint(buttonStyle.tint)
                        .scaleEffect(0.8)
                } else {
                    buttonIcon
                }
                
                Text(buttonStyle.title)
                    .fontWeight(.medium)
                    .font(.system(size: 17))
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .medium))
                    .opacity(0.7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.horizontal, 30)
            .background(
                Rectangle()
                    .fill(buttonStyle.tint.opacity(0.2))
                    .background(.ultraThinMaterial)
            )
            .foregroundColor(buttonStyle.tint)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(buttonStyle.tint.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: buttonStyle.tint.opacity(0.15), radius: 8, x: 0, y: 4)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.8), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1.0)
    }
    
    @ViewBuilder
    private var buttonIcon: some View {
        if let assetName = buttonStyle.assetName {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        } else {
            Image(systemName: buttonStyle.iconName)
                .font(.system(size: 18, weight: .medium))
        }
    }
    
    private var buttonStyle: ButtonStyleConfig {
        switch provider {
        case .google:
            return ButtonStyleConfig(
                title: "Увійти з Google",
                iconName: "globe",
                assetName: "google-logo",
                tint: .blue
            )
        case .apple:
            return ButtonStyleConfig(
                title: "Увійти з Apple",
                iconName: "apple.logo",
                assetName: "apple-logo",
                tint: .primary
            )
        }
    }
}

// MARK: - Button Styles

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

// MARK: - Supporting Types

private struct ButtonStyleConfig {
    let title: String
    let iconName: String
    let assetName: String?
    let tint: Color
}

// MARK: - Previews

#Preview {
    VStack(spacing: 16) {
        AuthButtonView(provider: .google, isLoading: false) {
            print("Google tap")
        }
        
        AuthButtonView(provider: .google, isLoading: true) {
            print("Google tap")
        }
        
        AuthButtonView(provider: .apple, isLoading: false) {
            print("Apple tap")
        }
        
        AuthButtonView(provider: .apple, isLoading: true) {
            print("Apple tap")
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Dark Mode") {
    VStack(spacing: 16) {
        AuthButtonView(provider: .google, isLoading: false) {
            print("Google tap")
        }
        
        AuthButtonView(provider: .apple, isLoading: false) {
            print("Apple tap")
        }
    }
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
