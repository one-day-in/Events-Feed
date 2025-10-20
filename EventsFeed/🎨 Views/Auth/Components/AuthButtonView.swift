import SwiftUI

struct AuthButtonView: View {
    let provider: AuthProvider
    let isLoading: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                        .tint(buttonStyle.progressColor)
                        .scaleEffect(0.8)
                } else {
                    buttonIcon
                }
                
                Text(buttonStyle.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .padding(.horizontal, 24)
            .background(buttonStyle.background)
            .foregroundColor(buttonStyle.foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(buttonStyle.borderColor, lineWidth: buttonStyle.borderWidth)
            )
            .shadow(color: buttonStyle.shadowColor.opacity(colorScheme == .dark ? 0.25 : 0.15), radius: 12, x: 0, y: 6)
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
                .frame(width: 22, height: 22)
        } else {
            Image(systemName: buttonStyle.iconName)
                .font(.system(size: 19, weight: .medium))
        }
    }
    
    private var buttonStyle: ButtonStyleConfig {
        switch provider {
        case .google:
            return ButtonStyleConfig(
                title: "Продовжити з Google",
                iconName: "globe",
                assetName: "google-logo",
                background: colorScheme == .dark ?
                    LinearGradient(
                        colors: [
                            Color(.systemGray2),
                            Color(.systemGray6)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ) :
                    LinearGradient(
                        colors: [
                            .white,
                            Color(.systemGray)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                foregroundColor: .primary,
                borderColor: .primary.opacity(0.15),
                borderWidth: 1,
                shadowColor: .black,
                progressColor: .gray
            )
        case .apple:
            return ButtonStyleConfig(
                title: "Продовжити з Apple",
                iconName: "apple.logo",
                assetName: "apple-logo",
                background: LinearGradient(
                    colors: colorScheme == .dark ?
                        [Color(.systemGray), Color(.systemGray3)] :
                        [.black, Color(.systemGray2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                foregroundColor: colorScheme == .dark ? .black : .white,
                borderColor: .clear,
                borderWidth: 0,
                shadowColor: colorScheme == .dark ? .white.opacity(0.3) : .black,
                progressColor: colorScheme == .dark ? .black : .white
            )
        }
    }
}

// MARK: - Button Styles

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Supporting Types

private struct ButtonStyleConfig {
    let title: String
    let iconName: String
    let assetName: String?
    let background: LinearGradient
    let foregroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let shadowColor: Color
    let progressColor: Color
}

// MARK: - Previews

#Preview {
    VStack(spacing: 20) {
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
    .background(
        LinearGradient(
            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
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
