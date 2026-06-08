import Foundation

struct Photo: Codable, Identifiable {
    let id: Int
    let url: String
    let description: String?
    let albumId: Int?
}
