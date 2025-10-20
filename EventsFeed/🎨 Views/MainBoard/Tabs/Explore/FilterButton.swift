// FilterButton.swift
import SwiftUI

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
            }
            action()
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color(.systemGray6)
                        }
                    }
                )
                .cornerRadius(20)
                .shadow(
                    color: isSelected ? .blue.opacity(0.3) : .clear,
                    radius: isSelected ? 4 : 0,
                    x: 0,
                    y: 2
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
    }
}

#Preview {
    VStack {
        FilterButton(title: "Найближчі", isSelected: true, action: {})
        FilterButton(title: "Анонси", isSelected: false, action: {})
    }
    .padding()
}
