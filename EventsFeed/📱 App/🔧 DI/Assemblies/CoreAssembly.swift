import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.registerMainActor(ErrorHandler.self) { _ in
            return ErrorHandler()
        }
        .inObjectScope(.container)
        
        container.registerMainActor(LoadingService.self) { _ in
            return LoadingService()
        }
        .inObjectScope(.container)
        
        container.register(PKCEGenerator.self) { _ in
            PKCEGenerator()
        }
        .inObjectScope(.container)
        
        container.register(KeychainHelper.self) { _ in
            KeychainHelper()
        }
        .inObjectScope(.container)
        
        container.register(OAuthFlow.self) { resolver in
            let pkceGenerator = resolver.resolve(PKCEGenerator.self)!
            return OAuthFlow(pkceGenerator: pkceGenerator)
        }.inObjectScope(.container)
        
        container.register(MusicServiceTokenStore.self) { resolver in
            let keychainHelper = resolver.resolve(KeychainHelper.self)!
            return MusicServiceTokenStore(keychain: keychainHelper)
        }
        .inObjectScope(.container)
    }
}
