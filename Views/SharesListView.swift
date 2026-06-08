import SwiftUI

struct SharesListView: View {
    @StateObject private var viewModel = SharesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Ładowanie udostępnień...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if viewModel.shares.isEmpty {
                    Text("Brak udostępnień")
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
                            ForEach(viewModel.shares) { share in
                                NavigationLink {
                                    if let photo = share.photo {
                                        PhotoDetailView(photo: photo)
                                    }
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {

                                        // MINIATURA ZDJĘCIA
                                        AsyncImage(url: URL(string: APIConfig.baseURL + (share.photo?.url ?? ""))) { phase in
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

                                        // INFORMACJA KTO UDOSTĘPNIŁ
                                        Text("Od: \(share.sharedByUsername ?? "Nieznany")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        Task { await viewModel.delete(share: share) }
                                    } label: {
                                        Label("Usuń udostępnienie", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Udostępnione")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadShares()
            }
        }
    }
}
