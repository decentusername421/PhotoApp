import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    // LOGIN
    func login(email: String, password: String) async throws -> String {
        guard let url = URL(string: "\(APIConfig.baseURL)/api/auth/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        return authResponse.token
    }
    
    // REGISTER — poprawna wersja
    func register(username: String, email: String, password: String) async throws {
        guard let url = URL(string: "\(APIConfig.baseURL)/api/auth/register") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Jeśli backend zwrócił błąd — spróbuj odczytać treść
        if !(200..<300).contains(httpResponse.statusCode) {
            if let backendMessage = String(data: data, encoding: .utf8),
               backendMessage.isEmpty == false {
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: backendMessage
                ])
            }
            
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "Błąd serwera (\(httpResponse.statusCode))"
            ])
        }
    }
}
