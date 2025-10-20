import Foundation
import MusicKit
import MediaPlayer

@MainActor
final class AppleMusicServiceClient: BaseMusicServiceClient<
    AppleMusicConstants,
    AppleMusicAuthHandler,
    AppleMusicTokenStorage
> {
    private var hasExplicitlyConnected: Bool {
        get { UserDefaults.standard.bool(forKey: "AppleMusicExplicitlyConnected") }
        set { UserDefaults.standard.set(newValue, forKey: "AppleMusicExplicitlyConnected") }
    }

    convenience init(errorService: ErrorService = .shared) {
        let authHandler = AppleMusicAuthHandler()
        let tokenStorage = AppleMusicTokenStorage()

        self.init(
            webAuthHandler: authHandler,
            tokenStorage: tokenStorage,
            errorService: errorService,
            serviceType: .appleMusic
        )

        updateConnectionState()
    }

    override func authenticate() {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            await performNativeAuthentication()
        }
    }

    @MainActor
    private func performNativeAuthentication() async {
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                let subscription = try? await MusicSubscription.current
                let hasSubscription = subscription?.canPlayCatalogContent ?? false

                hasExplicitlyConnected = true
                handleAuthSuccess(accessToken: "apple_music_native_access")

                if !hasSubscription {
                    errorMessage = "⚠️ Підписка Apple Music неактивна"
                }

            case .denied:
                throw MusicServiceAuthError.accessDenied
            case .restricted:
                throw MusicServiceAuthError.restricted
            default:
                throw MusicServiceAuthError.serviceError("Невідомий статус авторизації")
            }
        } catch {
            handleError(error.localizedDescription)
        }
    }

    override func isAuthenticated() -> Bool {
        MusicAuthorization.currentStatus == .authorized && hasExplicitlyConnected
    }

    override func disconnect() {
        hasExplicitlyConnected = false
        super.disconnect()
    }
}
