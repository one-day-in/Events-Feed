import Foundation

public struct AuthSignInOptions {
    public let presentationContext: Any?
    public let scopes: [String]?
    public let parameters: [String: Any]?
    
    public init(presentationContext: Any? = nil, scopes: [String]? = nil, parameters: [String: Any]? = nil) {
        self.presentationContext = presentationContext
        self.scopes = scopes
        self.parameters = parameters
    }
    
    public static let `default` = AuthSignInOptions()
}
