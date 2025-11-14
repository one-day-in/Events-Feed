import Foundation

class ApiClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        // Створення URL
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw AppError.api(.invalidURL)
        }
        
        // Створення запиту
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Додавання заголовків
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Додавання параметрів для POST/PUT запитів
        if let parameters = endpoint.parameters,
           [.post, .put].contains(endpoint.method) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        // Виконання запиту
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw AppError.api(.requestFailed(error.localizedDescription))
        }
        
        // Перевірка HTTP відповіді
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.api(.invalidResponse)
        }
        
        // Перевірка статус-коду
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "HTTP помилка"
            throw AppError.api(.httpError(statusCode: httpResponse.statusCode, message: message))
        }
        
        // Декодування JSON
        do {
                let decoder = JSONDecoder()
                
                // Додай для дебагу:
                print("🔗 Request URL: \(url.absoluteString)")
                print("📦 Response Status Code: \(httpResponse.statusCode)")
                print("📦 Response Data Size: \(data.count) bytes")
                
                // Спроба вивести JSON як строку для перевірки
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Raw JSON (first 500 chars): \(String(jsonString.prefix(500)))")
                }
                
                let result = try decoder.decode(T.self, from: data)
                print("✅ Successfully decoded \(T.self)")
                return result
                
            } catch let decodingError as DecodingError {
                print("❌ Detailed decoding error:")
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found: \(context)")
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch: \(context)")
                case .valueNotFound(let type, let context):
                    print("Value '\(type)' not found: \(context)")
                @unknown default:
                    print("Unknown decoding error")
                }
                print("Coding path: \(decodingError)")
                throw AppError.api(.decodingFailed(decodingError.localizedDescription))
            } catch {
                print("❌ General decoding error: \(error)")
                throw AppError.api(.decodingFailed(error.localizedDescription))
            }
    }
}
