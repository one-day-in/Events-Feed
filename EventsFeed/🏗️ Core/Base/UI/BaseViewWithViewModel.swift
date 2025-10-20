// BaseViewWithViewModel.swift
import SwiftUI

/// База для View з автоматичним @StateObject
struct BaseView<Content: View, VM: ObservableObject>: View {
    @StateObject var viewModel: VM
    let content: (VM) -> Content
    
    init(viewModel: @autoclosure @escaping () -> VM, @ViewBuilder content: @escaping (VM) -> Content) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.content = content
    }
    
    var body: some View {
        content(viewModel)
    }
}
