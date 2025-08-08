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
    let shape = RoundedRectangle(cornerRadius: 10)

    // MARK: - Body View

    var body: some View {
        actionButtons
    }

    // MARK: - Action Buttons Wrapper

    private var actionButtons: some View {
        ZStack {
            if hasGameStarted {
                /// Main control panel for the active game
                HStack {
                    Spacer()
                    discardPileBody
                    Spacer()
                    VStack {
                        Button("New Game") { withAnimation { startNewGame() } }
                            .font(.title2)
                        Button(action: {
                            withAnimation(
                                .spring(response: 0.6, dampingFraction: 0.6)
                            ) {
                                shuffle()
                            }
                        }) {
                            Image(systemName: "shuffle.circle")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                    deckBody
                    Spacer()
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

    // MARK: - Deck View

    @ViewBuilder
    private var deckBody: some View {
        ZStack {
            ForEach(deck) { card in
                shape
                    .fill(.red)  // card back
                    /// Tag placeholder with card's ID
                    .matchedGeometryEffect(id: card.id, in: namespace)
            }
        }
        .frame(width: 80, height: 120)
        .onTapGesture {
            withAnimation { dealThreeMore() }
        }
        .overlay(
            Text("+3")
                .font(.headline)
                .foregroundColor(.white)
                .opacity(isDeckEmpty ? 0 : 1)
        )
    }

    // MARK: - Discard Pile View

    private var discardPileBody: some View {
        ZStack {
            shape
                .stroke(lineWidth: 2)
                .opacity(0.3)

            ForEach(discardPile) { card in
                CardView(
                    card: card,
                    isSelected: false,
                    setEvalStatus: .none,
                    namespace: namespace
                )
                .matchedGeometryEffect(id: card.id, in: namespace)
            }
        }
        .frame(width: 80, height: 120)
    }

}
