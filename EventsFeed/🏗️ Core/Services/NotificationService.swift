import Foundation
import Combine

final class NotificationService {
    static let shared = NotificationService()
    private let center = NotificationCenter.default
    
    // MARK: - Publishers
    
    var appInitialized: AnyPublisher<Void, Never> {
        center.publisher(for: .appInitializationCompleted)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    var musicServiceAuthSuccess: AnyPublisher<(MusicServiceType, String), Never> {
        center.publisher(for: .musicServiceAuthSuccess)
            .compactMap { notification in
                guard let serviceType = notification.userInfo?[NotificationKeys.serviceType] as? MusicServiceType,
                      let token = notification.userInfo?[NotificationKeys.accessToken] as? String else { return nil }
                return (serviceType, token)
            }
            .eraseToAnyPublisher()
    }

    var musicServiceConnectionChanged: AnyPublisher<(MusicServiceType, Bool), Never> {
        center.publisher(for: .musicServiceConnectionStateChanged)
            .compactMap { notification in
                guard let serviceType = notification.userInfo?[NotificationKeys.serviceType] as? MusicServiceType,
                      let isConnected = notification.userInfo?[NotificationKeys.isConnected] as? Bool else { return nil }
                return (serviceType, isConnected)
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Post Events
    
    func postAppInitialized() {
        center.post(name: .appInitializationCompleted, object: nil)
    }

    func postMusicServiceAuthSuccess(serviceType: MusicServiceType, token: String) {
        center.post(name: .musicServiceAuthSuccess, object: nil, userInfo: [
            NotificationKeys.serviceType: serviceType,
            NotificationKeys.accessToken: token
        ])
    }

    func postMusicServiceDisconnected(serviceType: MusicServiceType) {
        center.post(name: .musicServiceDisconnected, object: nil, userInfo: [
            NotificationKeys.serviceType: serviceType
        ])
    }

    func postConnectionStateChanged(serviceType: MusicServiceType, isConnected: Bool) {
        center.post(name: .musicServiceConnectionStateChanged, object: nil, userInfo: [
            NotificationKeys.serviceType: serviceType,
            NotificationKeys.isConnected: isConnected
        ])
    }
}
