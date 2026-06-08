import Foundation
import SwiftUI
import Combine

@MainActor
final class AlbumsViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @AppStorage("authToken") var authToken: String = ""

    func loadAlbums() async {
        guard !authToken.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            albums = try await AlbumService.shared.fetchAlbums(token: authToken)
        } catch {
            errorMessage = "Nie udało się pobrać albumów"
        }

        isLoading = false
    }

    func createAlbum(name: String) async {
        guard !authToken.isEmpty else { return }

        do {
            try await AlbumService.shared.createAlbum(name: name, token: authToken)
            await loadAlbums()
        } catch {
            errorMessage = "Nie udało się utworzyć albumu"
        }
    }

    func delete(album: Album) async {
        guard !authToken.isEmpty else { return }

        do {
            try await AlbumService.shared.deleteAlbum(id: album.id, token: authToken)
            await loadAlbums()
        } catch {
            errorMessage = "Nie udało się usunąć albumu"
        }
    }
}
