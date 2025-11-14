import Foundation

class ConcertService {
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func fetchConcerts(offset: Int = 0) async throws -> [Concert] {
//            let response: DTOConcertResponse = try await apiClient.request(
//                Endpoint.getConcerts(offset: offset)
//            )
//            
//            return ConcertMapper.map(response)
        return []
        }
}
