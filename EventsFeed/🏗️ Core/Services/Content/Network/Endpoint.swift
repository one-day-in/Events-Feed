import Foundation

enum Endpoint {
    case getConcerts(offset: Int, limit: Int = 24, language: String = "en")
    
    var baseURL: String {
        return "https://concert.ua"
    }
    
    var path: String {
        switch self {
        case .getConcerts:
            return "/api/v3/items"
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .getConcerts(let offset, let limit, let language):
            return [
                "categoriesIds[]": "19",
                "language": language,
                "limit": "\(limit)",
                "offset": "\(offset)",
                "sortType": "sort_by_popularity"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getConcerts:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        
        // Додаємо query parameters якщо вони є
        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        return components?.url
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
