import Foundation

final class CoreAssembly: AppAssembly {

    func register(in container: DIContainer) {

        // MARK: - Crypto & Auth utilities
        container.register(PKCEGenerator.self) { _ in
            PKCEGenerator()
        }

        container.register(KeychainHelper.self) { _ in
            KeychainHelper()
        }

        // MARK: - Auth Core Flow
        container.register(OAuthFlow.self) { resolver in
            OAuthFlow(
                pkceGenerator: resolver.resolve(PKCEGenerator.self)!
            )
        }

        // MARK: - Token Store
        container.register(MusicServiceTokenStore.self) { resolver in
            MusicServiceTokenStore(
                keychain: resolver.resolve(KeychainHelper.self)!
            )
        }
    }
}
