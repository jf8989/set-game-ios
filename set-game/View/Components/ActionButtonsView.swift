//  View/Components/ActionButtonsView.swift

import SwiftUI

struct ActionButtonsView: View {
    let hasGameStarted: Bool
    let startNewGame: () -> Void
    let dealThreeMore: () -> Void
    let isDeckEmpty: Bool
    let onStartGame: () -> Void
    let shuffle: () -> Void
    let deck: [CardSet]
    let discardPile: [CardSet]
    let namespace: Namespace.ID

    // MARK: - Body View

    var body: some View {
        actionButtons
    }

    // MARK: - Sub.Views

    private var actionButtons: some View {
        ZStack {
            if hasGameStarted {
                /// Main control panel for the active game
                HStack {
                    deckBody
                    Spacer()
                    Button("New Game") { withAnimation { startNewGame() } }
                        .font(.title2)
                    Spacer()
                    Button("shuffle.circle") { shuffle() }
                        .font(.title2)
                    Spacer()
                    discardPileBody
                }
                .frame(maxHeight: 120)
            }

            /// Buttons can live below the control panel
            HStack(spacing: 22) {
                if !hasGameStarted {
                    Button("Get Started!") { withAnimation { onStartGame() } }
                }
            }
            .font(.title2)
            .padding()
        }
    }

    private var deckBody: some View {
        Text("[DECK]")
            .frame(width: 80, height: 120)
            .border(Color.primary)
            .onTapGesture {
                dealThreeMore()
            }
    }

    private var discardPileBody: some View {
        Text("[DISCARD]")
            .frame(width: 80, height: 120)
            .border(Color.primary)
    }

}
