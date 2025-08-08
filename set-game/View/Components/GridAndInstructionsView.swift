//  View/Components/GridAndInstructionsView.swift

import SwiftUI

struct GridAndInstructionsView: View {
    /// Dependency injection: pass data in
    let tableCards: [CardSet]
    let hasGameStarted: Bool
    let isSelected: (CardSet) -> Bool
    let setEvalStatus: SetEvalStatus
    let namespace: Namespace.ID
    let select: (CardSet) -> Void

    // MARK: - Body View

    var body: some View {
        mainView
    }

    // MARK: - Center Screen View

    private var mainView: some View {
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
        AspectVGrid(items: tableCards, aspectRatio: 2/3) { card in
            CardView(
                card: card,
                isSelected: isSelected(card),
                setEvalStatus: setEvalStatus,
                namespace: namespace
            )
            .padding(4)
            .onTapGesture {
                select(card)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Instructions Sub.View

    private var gameInstructions: some View {
        VStack(spacing: 8) {
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
        .frame(maxWidth: 500)
        .padding(.horizontal)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity)
    }
}
