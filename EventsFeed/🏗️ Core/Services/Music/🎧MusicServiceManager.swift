import Foundation
import Combine

final class MusicServiceManager: ObservableObject {
    @Published private(set) var connectionStates: [MusicServiceType: ConnectionState] = [:]
    private var clients: [MusicServiceType: MusicServiceClient]
    
    enum ConnectionState {
        case disconnected
        case connecting
        case connected
        case error(AppError)
        
        var isConnected: Bool {
            if case .connected = self { return true }
            return false
        }
    }
    
    init(clients: [MusicServiceType: MusicServiceClient]) {
        self.clients = clients
        setupInitialStates()
    }
    
    // MARK: - Public API
    func getClient(for service: MusicServiceType) -> MusicServiceClient? {
        return clients[service]
    }
    
    func connectService(_ type: MusicServiceType) async throws {
        let currentState = getConnectionState(for: type)
        
        if case .connecting = currentState {
            throw AppError.system(.invalidConfiguration)
        }
        
        if case .connected = currentState {
            throw AppError.system(.invalidConfiguration)
        }
        
        // Перевіряємо наявність клієнта
        guard let client = getClient(for: type) else {
            let error = AppError.system(.invalidConfiguration)
            await updateConnectionState(for: type, state: .error(error))
            throw error
        }
        
        print("🔗 Connecting \(type)...")
        await updateConnectionState(for: type, state: .connecting)
        
        do {
            try await client.authenticate()
            
            let isAuthenticated = client.checkAuthenticationStatus()
            if isAuthenticated {
                await updateConnectionState(for: type, state: .connected)
                print("✅ Successfully connected \(type)")
            } else {
                let error = AppError.auth(.tokenRefreshFailed)
                await updateConnectionState(for: type, state: .error(error))
                throw error
            }
        } catch {
            let appError = error.toAppError(context: "Connection to \(type) failed")
            await updateConnectionState(for: type, state: .error(appError))
            print("❌ Failed to connect \(type): \(error)")
            throw appError
        }
    }
    
    func restoreConnections() async {
        print("🔄 Restoring music service connections...")
        
        await withTaskGroup(of: (MusicServiceType, Bool).self) { group in
            for serviceType in MusicServiceType.allCases {
                group.addTask {
                    guard let client = self.getClient(for: serviceType) else {
                        return (serviceType, false)
                    }
                    let isAuthenticated = client.checkAuthenticationStatus()
                    return (serviceType, isAuthenticated)
                }
            }
            
            for await (serviceType, isAuthenticated) in group {
                let state: ConnectionState = isAuthenticated ? .connected : .disconnected
                await self.updateConnectionState(for: serviceType, state: state)
                print(isAuthenticated ? "✅ Restored connection to \(serviceType)" : "🔴 \(serviceType) is not connected")
            }
        }
    }
    
    func disconnectService(_ type: MusicServiceType) {
        print("🔗 Disconnecting \(type)...")
        
        guard let client = getClient(for: type) else {
            Task { @MainActor in
                connectionStates[type] = .disconnected
            }
            return
        }
        
        client.disconnect()
        
        Task { @MainActor in
            connectionStates[type] = .disconnected
        }
        print("✅ Disconnected \(type)")
    }
    
    func disconnectAll() {
        print("🔗 Disconnecting all services...")
        for serviceType in MusicServiceType.allCases {
            disconnectService(serviceType)
        }
        print("✅ Disconnected all music services")
    }
    
    func getConnectionState(for service: MusicServiceType) -> ConnectionState {
        return connectionStates[service] ?? .disconnected
    }
    
    // MARK: - Private Helpers
    private func setupInitialStates() {
        Task { @MainActor in
            for serviceType in MusicServiceType.allCases {
                connectionStates[serviceType] = .disconnected
            }
        }
    }
    
    @MainActor
    private func updateConnectionState(for type: MusicServiceType, state: ConnectionState) {
        connectionStates[type] = state
    }
}
