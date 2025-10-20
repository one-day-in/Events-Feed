//// Views/App/Loading/Components/AuthTransitionView.swift
//import SwiftUI
//
//struct AuthTransitionView: View {
//    let transitionState: AuthTransitionState
//    @State private var scale: CGFloat = 0.5
//    @State private var opacity: Double = 0
//    @State private var rotation: Double = 0
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.8)
//                .ignoresSafeArea()
//            
//            VStack(spacing: 24) {
//                Image(systemName: "checkmark.circle.fill")
//                    .font(.system(size: 80))
//                    .foregroundStyle(
//                        LinearGradient(
//                            colors: [.green, .blue],
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .scaleEffect(scale)
//                    .rotationEffect(.degrees(rotation))
//                
//                Text("Успішно!")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .opacity(opacity)
//            }
//        }
//        .onAppear {
//            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
//                scale = 1.0
//                opacity = 1.0
//            }
//            
//            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
//                rotation = 360
//            }
//        }
//    }
//}
//
//#Preview {
//    AuthTransitionView(transitionState: .animating)
//}
