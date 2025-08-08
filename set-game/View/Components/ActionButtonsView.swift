//  View/Sub-View/ActionButtonsView.swift

import SwiftUI

struct ActionButtonsView: View {
    let hasGameStarted: Bool
    let startNewGame: () -> Void
    let dealThreeMore: () -> Void
    let isDeckEmpty: Bool
    let onStartGame: () -> Void

    // MARK: - Body View
    
    var body: some View {
        actionButtons
    }

    // MARK: - Action Buttons View

    private var actionButtons: some View {
        HStack(spacing: 22) {
            if hasGameStarted {
                Button("New Game") {
                    withAnimation { startNewGame() }
                }
                Button("Deal 3 More") {
                    withAnimation { dealThreeMore() }
                }
                .disabled(isDeckEmpty)
            }
            if !hasGameStarted {
                Button("Get Started!") {
                    withAnimation {
                        onStartGame()
                    }
                }
            }
        }.font(.title2)
            .padding(.bottom, 10)
    }

}
