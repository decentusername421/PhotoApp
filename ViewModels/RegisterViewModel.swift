import Foundation
import SwiftUI
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    func register() async {
        errorMessage = nil
        successMessage = nil

        guard password == confirmPassword else {
            errorMessage = "Hasła nie są takie same"
            return
        }

        isLoading = true

        do {
            try await AuthService.shared.register(
                username: username,
                email: email,
                password: password
            )
            successMessage = "Konto zostało utworzone — możesz się zalogować"
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
