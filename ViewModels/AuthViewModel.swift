import Foundation
import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {

    // MARK: - Stan logowania
    @Published var isAuthenticated: Bool = false
    @Published var username: String = ""

    // MARK: - Token
    @AppStorage("authToken") var authToken: String = "" {
        didSet {
            isAuthenticated = !authToken.isEmpty
        }
    }

    // MARK: - Avatar
    @AppStorage("avatarData") var avatarData: Data?

    func setAvatar(_ data: Data?) {
        avatarData = data
    }

    // MARK: - Inicjalizacja
    init() {
        isAuthenticated = !authToken.isEmpty
    }

    // MARK: - Wylogowanie
    func logout() {
        authToken = ""
        username = ""
        avatarData = nil
        isAuthenticated = false
    }
}

