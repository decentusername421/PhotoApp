import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var viewModel = PhotosViewModel()
    @StateObject private var albumsViewModel = AlbumsViewModel()

    @State private var showAlbumPicker = false
    @State private var showShareAlert = false
    @State private var shareUserId = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Zdjęcie
                AsyncImage(url: URL(string: APIConfig.baseURL + photo.url)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                            .shadow(radius: 6)
                            .padding(.horizontal)

                    case .failure(_):
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.red)
                            )

                    default:
                        ProgressView()
                            .frame(height: 300)
                    }
                }

                // Przyciski
                VStack(spacing: 12) {
                    Button {
                        showAlbumPicker = true
                    } label: {
                        Label("Dodaj do albumu", systemImage: "folder.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        showShareAlert = true
                    } label: {
                        Label("Udostępnij", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(role: .destructive) {
                        Task { await viewModel.delete(photo: photo) }
                    } label: {
                        Label("Usuń zdjęcie", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Szczegóły zdjęcia")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await albumsViewModel.loadAlbums()
        }
        .sheet(isPresented: $showAlbumPicker) {
            NavigationView {
                List {
                    ForEach(albumsViewModel.albums) { album in
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.blue)
                            Text(album.name)
                        }
                        .padding(.vertical, 6)
                        .onTapGesture {
                            Task {
                                await viewModel.assign(photo: photo, to: album)
                                showAlbumPicker = false
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Wybierz album")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Zamknij") { showAlbumPicker = false }
                    }
                }
            }
        }
        .alert("Udostępnij zdjęcie", isPresented: $showShareAlert) {
            TextField("ID użytkownika", text: $shareUserId)
                .keyboardType(.numberPad)

            Button("Udostępnij") {
                if let id = Int(shareUserId) {
                    Task {
                        try? await ShareService.shared.createShare(
                            photoId: photo.id,
                            userId: id,
                            token: viewModel.authToken
                        )
                        showShareAlert = false
                        shareUserId = ""
                    }
                }
            }

            Button("Anuluj", role: .cancel) { showShareAlert = false }
        } message: {
            Text("Podaj ID użytkownika, któremu chcesz udostępnić zdjęcie")
        }
    }
}
