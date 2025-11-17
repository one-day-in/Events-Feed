import Foundation
import Combine

@MainActor
final class LoadingService: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var loadingStates: [String: Bool] = [:]
    
    private var loadingCount: Int = 0 {
        didSet {
            isLoading = loadingCount > 0
        }
    }
    
    // MARK: - Public API
    
    func startLoading(context: String = "global") {
        loadingCount += 1
        loadingStates[context] = true
        print("🔄 Loading started: \(context) (count: \(loadingCount))")
    }
    
    func stopLoading(context: String = "global") {
        loadingCount = max(0, loadingCount - 1)
        loadingStates[context] = false
        print("✅ Loading stopped: \(context) (count: \(loadingCount))")
    }
    
    func setLoading(_ loading: Bool, context: String = "global") {
        if loading {
            startLoading(context: context)
        } else {
            stopLoading(context: context)
        }
    }
    
    func isLoading(context: String) -> Bool {
        loadingStates[context] == true
    }
    
    // MARK: - Async helpers
    
    func trackLoading<T>(_ operation: () async throws -> T, context: String = "global") async throws -> T {
        startLoading(context: context)
        defer { stopLoading(context: context) }
        return try await operation()
    }
    
    // MARK: - Reset
    
    func reset() {
        loadingCount = 0
        loadingStates.removeAll()
        isLoading = false
    }
}
