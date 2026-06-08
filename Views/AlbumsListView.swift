import SwiftUI

struct AlbumsListView: View {
    @StateObject private var viewModel = AlbumsViewModel()
    @State private var showCreateAlbum = false
    @State private var newAlbumName = ""

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Ładowanie albumów...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if viewModel.albums.isEmpty {
                    Text("Brak albumów")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(viewModel.albums) { album in
                                NavigationLink {
                                    AlbumPhotosView(album: album)
                                } label: {
                                    AlbumTileView(album: album)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        Task { await viewModel.delete(album: album) }
                                    } label: {
                                        Label("Usuń album", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Albumy")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateAlbum = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .task {
                await viewModel.loadAlbums()
            }
            .alert("Nowy album", isPresented: $showCreateAlbum) {
                TextField("Nazwa albumu", text: $newAlbumName)

                Button("Utwórz") {
                    Task {
                        await viewModel.createAlbum(name: newAlbumName)
                        newAlbumName = ""
                    }
                }

                Button("Anuluj", role: .cancel) { }
            } message: {
                Text("Podaj nazwę nowego albumu")
            }
        }
    }
}
