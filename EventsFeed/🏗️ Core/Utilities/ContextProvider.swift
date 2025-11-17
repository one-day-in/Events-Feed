import AuthenticationServices

protocol PresentationContextProviding {
    var presentingViewController: UIViewController? { get }
    var presentationAnchor: ASPresentationAnchor? { get }
}

final class DefaultPresentationContextProvider: PresentationContextProviding {
    var presentingViewController: UIViewController? {
        // Логіка з твого extension, але локально тут
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        var vc = keyWindow?.rootViewController
        while let presented = vc?.presentedViewController {
            vc = presented
        }
        return vc
    }

    var presentationAnchor: ASPresentationAnchor? {
        presentingViewController?.view.window
    }
}
