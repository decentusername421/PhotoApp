import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Rejestracja")
                .font(.largeTitle)
                .bold()

            TextField("Nazwa użytkownika", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Hasło", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            SecureField("Powtórz hasło", text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            if let success = viewModel.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .font(.caption)
            }

            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("Utwórz konto") {
                    Task { await viewModel.register() }
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Masz już konto? Zaloguj się") {
                dismiss()
            }
            .font(.caption)
            .padding(.top, 8)
        }
        .padding()
    }
        
}

