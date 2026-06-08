import SwiftUI
import PhotosUI

struct PhotosListView: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var viewModel = PhotosViewModel()
    @StateObject private var albumsViewModel = AlbumsViewModel()

    @State private var selectedItem: PhotosPickerItem?
    @State private var showAlbumPickerForPhoto: Photo?

    // UDOSTĘPNIANIE
    @State private var showShareAlertForPhoto: Photo?
    @State private var shareUserId: String = ""

    var body: some View {
        NavigationView {
            VStack {

                // MARK: - Dodawanie zdjęcia
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Dodaj zdjęcie", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            await viewModel.uploadPhoto(data: data)
                        }
                    }
                }
                .padding(.bottom, 10)

                // MARK: - Lista zdjęć
                if viewModel.isLoading {
                    ProgressView("Ładowanie zdjęć...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if viewModel.photos.isEmpty {
                    Text("Brak zdjęć")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(viewModel.photos) { photo in

                                NavigationLink {
                                    PhotoDetailView(photo: photo)
                                } label: {
                                    AsyncImage(url: URL(string: APIConfig.baseURL + photo.url)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipped()
                                                .cornerRadius(12)
                                                .shadow(radius: 4)
                                                .transition(.opacity.combined(with: .scale))

                                        case .failure(_):
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.red.opacity(0.2))
                                                .frame(width: 120, height: 120)
                                                .overlay(
                                                    Image(systemName: "exclamationmark.triangle")
                                                        .foregroundColor(.red)
                                                )

                                        default:
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 120, height: 120)
                                                .overlay(ProgressView())
                                        }
                                    }
                                }
                                .contextMenu {

                                    // USUWANIE
                                    Button(role: .destructive) {
                                        Task { await viewModel.delete(photo: photo) }
                                    } label: {
                                        Label("Usuń zdjęcie", systemImage: "trash")
                                    }

                                    // DODAWANIE DO ALBUMU
                                    if !albumsViewModel.albums.isEmpty {
                                        Button {
                                            showAlbumPickerForPhoto = photo
                                        } label: {
                                            Label("Dodaj do albumu", systemImage: "folder.badge.plus")
                                        }
                                    }

                                    // UDOSTĘPNIANIE
                                    Button {
                                        showShareAlertForPhoto = photo
                                    } label: {
                                        Label("Udostępnij", systemImage: "square.and.arrow.up")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Moje zdjęcia")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Wyloguj") {
                        auth.logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .task {
                await viewModel.loadPhotos()
                await albumsViewModel.loadAlbums()
            }

            // MARK: - Sheet: wybór albumu
            .sheet(item: $showAlbumPickerForPhoto) { photo in
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
                                    showAlbumPickerForPhoto = nil
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("Wybierz album")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Zamknij") {
                                showAlbumPickerForPhoto = nil
                            }
                        }
                    }
                }
            }

            // MARK: - Alert: udostępnianie
            .alert("Udostępnij zdjęcie", isPresented: Binding(
                get: { showShareAlertForPhoto != nil },
                set: { if !$0 { showShareAlertForPhoto = nil } }
            )) {
                TextField("ID użytkownika", text: $shareUserId)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Button("Udostępnij") {
                    if let photo = showShareAlertForPhoto,
                       let userId = Int(shareUserId) {
                        Task {
                            try? await ShareService.shared.createShare(
                                photoId: photo.id,
                                userId: userId,
                                token: viewModel.authToken
                            )
                            shareUserId = ""
                            showShareAlertForPhoto = nil
                        }
                    }
                }

                Button("Anuluj", role: .cancel) {
                    showShareAlertForPhoto = nil
                }
            } message: {
                Text("Podaj ID użytkownika, któremu chcesz udostępnić zdjęcie")
            }
        }
    }
}
