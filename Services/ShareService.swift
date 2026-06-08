import Foundation

final class ShareService {
    static let shared = ShareService()
    private init() {}

    // MARK: - Pobieranie udostępnień
    func fetchShares(token: String) async throws -> [Share] {
        guard let url = URL(string: "\(APIConfig.baseURL)/api/shares") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Share].self, from: data)
    }

    // MARK: - Tworzenie udostępnienia
    func createShare(photoId: Int, userId: Int, token: String) async throws {
        guard let url = URL(string: "\(APIConfig.baseURL)/api/shares") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "photoId": photoId,
            "sharedWithUserId": userId
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    // MARK: - Usuwanie udostępnienia
    func deleteShare(id: Int, token: String) async throws {
        guard let url = URL(string: "\(APIConfig.baseURL)/api/shares/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
