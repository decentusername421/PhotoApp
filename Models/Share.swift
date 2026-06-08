struct Share: Identifiable, Codable {
    let id: Int
    let photoId: Int
    let sharedWithUserId: Int
    let sharedByUsername: String?
    let photo: Photo?
}
