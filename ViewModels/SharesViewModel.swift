import Foundation
import SwiftUI
import Combine

@MainActor
final class SharesViewModel: ObservableObject {
    @Published var shares: [Share] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @AppStorage("authToken") private var authToken: String = ""

    func loadShares() async {
        guard !authToken.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            shares = try await ShareService.shared.fetchShares(token: authToken)
        } catch {
            errorMessage = "Nie udało się pobrać udostępnień"
        }

        isLoading = false
    }

    func delete(share: Share) async {
        guard !authToken.isEmpty else { return }

        do {
            try await ShareService.shared.deleteShare(id: share.id, token: authToken)
            await loadShares()
        } catch {
            errorMessage = "Nie udało się usunąć udostępnienia"
        }
    }
}
