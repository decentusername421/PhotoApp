import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        TabView {

            PhotosListView()
                .tabItem {
                    Label("Zdjęcia", systemImage: "photo.on.rectangle")
                }

            AlbumsListView()
                .tabItem {
                    Label("Albumy", systemImage: "folder")
                }

            SharesListView()
                .tabItem {
                    Label("Udostępnione", systemImage: "square.and.arrow.up")
                }

            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
    }
}
