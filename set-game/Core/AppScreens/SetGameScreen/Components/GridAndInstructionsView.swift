/// Path: Core/AppScreens/SetGameScreen/Components/GridAndInstructionsView.swift
/// Role: Switches between instructions and the grid

import SwiftUI

struct GridAndInstructionsView: View {
    let tableCards: [CardSet]
    let hasGameStarted: Bool
    let isSelected: (CardSet) -> Bool
    let setEvalStatus: SetEvalStatus
    let namespace: Namespace.ID
    let select: (CardSet) -> Void

    // MARK: - Body View
    var body: some View {
        ZStack {
            if hasGameStarted {
                cardGrid
            } else {
                gameInstructions
            }
        }
    }

    // MARK: - Card Grid Sub.View
    private var cardGrid: some View {
        AspectVGrid(items: tableCards, aspectRatio: SetGameTheme.cardAspectRatio) { card in
            CardView(
                card: card,
                isSelected: isSelected(card),
                setEvalStatus: setEvalStatus,
                namespace: namespace
            )
            .padding(SetGameTheme.cardGridItemPadding)
            .onTapGesture {
                withAnimation { select(card) }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Instructions Sub.View (unchanged behavior, literals → tokens)
    private var gameInstructions: some View {
        VStack(spacing: SetGameTheme.instructionsStackSpacing) {
            if !hasGameStarted {
                Text("How to Play:")
                    .font(.headline)
                Text(
                    """
                    - Select 3 cards you think form a Set.
                    - A Set means each property (color, symbol, shading, number) is all the same or all different.
                    - Tap to select/deselect. After 3 cards, see if you found a Set!
                    - A Set! gives you +3 points.
                    - A Mismatch gives you -1 points.
                    """
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: SetGameTheme.instructionsMaxWidth)
        .padding(.horizontal)
        .padding(.bottom, SetGameTheme.instructionsBottomPadding)
        .frame(maxWidth: .infinity)
    }
}
