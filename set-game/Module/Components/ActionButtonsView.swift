/// Path: set-game/Module/Components/ActionButtonsView.swift
/// Role: Toolbar for game actions; discard pile rendering simplified

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

    private let shape = RoundedRectangle(cornerRadius: SetGameTheme.cardCornerRadius)

    var body: some View {
        ZStack {
            if hasGameStarted {
                HStack {
                    Spacer()
                    discardPileBody
                    Spacer()

                    VStack(spacing: SetGameTheme.controlsVerticalButtonSpacing) {
                        Button("New Game") { withAnimation { startNewGame() } }
                            .font(.title2)
                            .buttonStyle(.bordered)

                        Button {
                            withAnimation(
                                .spring(
                                    response: SetGameTheme.shuffleSpringResponse,
                                    dampingFraction: SetGameTheme.shuffleSpringDamping
                                )
                            ) {
                                shuffle()
                            }
                        } label: {
                            Image(systemName: "shuffle.circle")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                    deckBody
                    Spacer()
                }
                .frame(maxHeight: SetGameTheme.controlsMaxHeight)
            }

            HStack(spacing: SetGameTheme.controlsInterItemSpacing) {
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
                    .fill(SetGameTheme.deckFillColor)
                    .matchedGeometryEffect(id: card.id, in: namespace)
            }
        }
        .frame(
            width: SetGameTheme.miniTileSize.width,
            height: SetGameTheme.miniTileSize.height
        )
        .onTapGesture { withAnimation { dealThreeMore() } }
        .overlay(
            Text("+\(SetGameRules.Rules.dealBatchCount)")
                .font(.headline)
                .foregroundColor(SetGameTheme.overlayTextColor)
                .opacity(
                    isDeckEmpty
                        ? SetGameTheme.opacityHidden
                        : SetGameTheme.opacityVisible
                )
        )
    }

    // MARK: - Discard Pile View
    private var discardPileBody: some View {
        ZStack {
            shape
                .stroke(lineWidth: SetGameTheme.discardStrokeLineWidth)
                .opacity(
                    discardPile.isEmpty
                        ? SetGameTheme.discardEmptyOpacity
                        : SetGameTheme.opacityVisible
                )

            if let lastCard = discardPile.last {
                CardView(
                    card: lastCard,
                    isSelected: false,
                    setEvalStatus: .none,
                    namespace: namespace
                )
            }
        }
        .frame(
            width: SetGameTheme.miniTileSize.width,
            height: SetGameTheme.miniTileSize.height
        )
    }
}

/// Role: Expose static helpers for logic-only testing
extension ActionButtonsView {
    internal static func deckOverlayOpacity(isDeckEmpty: Bool) -> Double {
        isDeckEmpty ? 0.0 : 0.5
    }

    internal static func discardStrokeOpacity(isDiscardEmpty: Bool) -> Double {
        isDiscardEmpty ? 0.0 : 1.0
    }
}
