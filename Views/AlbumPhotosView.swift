import SwiftUI

struct AlbumPhotosView: View {
    let album: Album
    @StateObject private var viewModel = PhotosViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Ładowanie zdjęć...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
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
                        ForEach(viewModel.photos.filter { $0.albumId == album.id }) { photo in
                            NavigationLink {
                                PhotoDetailView(photo: photo)
                            } label: {
                                AsyncImage(url: URL(string: APIConfig.baseURL + photo.url)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .clipped()
                                            .cornerRadius(12)
                                            .shadow(radius: 4)

                                    case .failure(_):
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.red.opacity(0.2))
                                            .frame(width: 110, height: 110)
                                            .overlay(
                                                Image(systemName: "exclamationmark.triangle")
                                                    .foregroundColor(.red)
                                            )

                                    default:
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.1))
                                            .frame(width: 110, height: 110)
                                            .overlay(ProgressView())
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(album.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadPhotos()
        }
    }
}
