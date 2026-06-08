import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {

            Text("PhotoApp")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Hasło", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button {
                Task { await login() }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Zaloguj")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .disabled(isLoading)

            Spacer()
        }
        .padding()
    }

    // MARK: - Logowanie
    func login() async {
        isLoading = true
        errorMessage = nil

        do {
            let token = try await AuthService.shared.login(
                email: email,
                password: password
            )

            // ZAPIS TOKENU
            auth.authToken = token

            // USTAWIAMY POPRAWNĄ FLAGĘ
            auth.isAuthenticated = true

        } catch {
            errorMessage = "Niepoprawne dane logowania"
        }

        isLoading = false
    }
}
