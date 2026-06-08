import Foundation
import SwiftUI
import Combine
import Combine

@MainActor
final class PhotosViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false
    @Published var isUploading: Bool = false
    @Published var errorMessage: String?

    @AppStorage("authToken") var authToken: String = ""

    // MARK: - Pobieranie zdjęć
    func loadPhotos() async {
        guard !authToken.isEmpty else {
            errorMessage = "Brak tokenu — zaloguj się"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            photos = try await PhotoService.shared.fetchPhotos(token: authToken)
        } catch {
            errorMessage = "Nie udało się pobrać zdjęć"
        }

        isLoading = false
    }

    // MARK: - Upload zdjęcia
    func uploadPhoto(data: Data) async {
        guard !authToken.isEmpty else {
            errorMessage = "Brak tokenu — zaloguj się"
            return
        }

        isUploading = true
        errorMessage = nil

        do {
            try await PhotoService.shared.uploadPhoto(data: data, token: authToken)
            await loadPhotos()
        } catch {
            errorMessage = "Nie udało się wysłać zdjęcia"
        }

        isUploading = false
    }

    // MARK: - Usuwanie zdjęcia
    func delete(photo: Photo) async {
        guard !authToken.isEmpty else {
            errorMessage = "Brak tokenu — zaloguj się"
            return
        }

        do {
            try await PhotoService.shared.deletePhoto(id: photo.id, token: authToken)
            await loadPhotos()
        } catch {
            errorMessage = "Nie udało się usunąć zdjęcia"
        }
    }

    // MARK: - Przypisywanie zdjęcia do albumu
    func assign(photo: Photo, to album: Album) async {
        guard !authToken.isEmpty else {
            errorMessage = "Brak tokenu — zaloguj się"
            return
        }

        do {
            try await PhotoService.shared.assignPhoto(photo.id, toAlbum: album.id, token: authToken)
            await loadPhotos()
        } catch {
            errorMessage = "Nie udało się przypisać zdjęcia do albumu"
        }
    }
}
