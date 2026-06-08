import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true

    @State private var selectedItem: PhotosPickerItem?
    @State private var avatarAnimation = false

    var body: some View {
        NavigationView {
            List {

                // MARK: - Nagłówek z gradientem
                Section {
                    VStack(spacing: 12) {
                        ZStack {
                            LinearGradient(
                                colors: [.blue.opacity(0.85), .purple.opacity(0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(height: 160)
                            .cornerRadius(20)
                            .overlay(
                                VStack(spacing: 10) {

                                    // MARK: - Avatar
                                    PhotosPicker(selection: $selectedItem, matching: .images) {
                                        ZStack {
                                            if let data = auth.avatarData,
                                               let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 90, height: 90)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 6)
                                                    .scaleEffect(avatarAnimation ? 1 : 0.8)
                                                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: avatarAnimation)
                                            } else {
                                                Circle()
                                                    .fill(.white.opacity(0.25))
                                                    .frame(width: 90, height: 90)
                                                    .overlay(
                                                        Text(initials(from: auth.username))
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .foregroundColor(.white)
                                                    )
                                                    .shadow(radius: 6)
                                            }
                                        }
                                    }
                                    .onChange(of: selectedItem) { _, newItem in
                                        Task {
                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                auth.setAvatar(data)
                                                avatarAnimation = true
                                            }
                                        }
                                    }

                                    // MARK: - Nazwa użytkownika
                                    Text(auth.username)
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white)

                                    Text("Użytkownik PhotoApp")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            )
                        }
                        .padding(.vertical, 8)
                    }
                }

                // MARK: - Ustawienia
                Section("Ustawienia") {

                    // MARK: - Motyw aplikacji
                    Picker("Motyw", selection: $appTheme) {
                        Text("Systemowy").tag("system")
                        Text("Jasny").tag("light")
                        Text("Ciemny").tag("dark")
                    }
                    .pickerStyle(.segmented)

                    // MARK: - Powiadomienia
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Powiadomienia", systemImage: "bell.badge")
                            .foregroundStyle(.orange)
                    }
                }

                // MARK: - Konto
                Section {
                    Button(role: .destructive) {
                        auth.logout()
                    } label: {
                        Label("Wyloguj", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profil")
        }
        .onAppear {
            avatarAnimation = true
        }
        .preferredColorScheme(colorSchemeFromSetting())
    }

    // MARK: - Funkcje pomocnicze

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }
        return initials.map { String($0) }.joined().uppercased()
    }

    private func colorSchemeFromSetting() -> ColorScheme? {
        switch appTheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
