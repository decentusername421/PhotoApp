import SwiftUI

struct AlbumTileView: View {
    let album: Album

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))

                Image(systemName: "folder.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue.opacity(0.8))
            }
            .frame(height: 140)
            .shadow(radius: 4)

            Text(album.name)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 4)
        }
    }
}

