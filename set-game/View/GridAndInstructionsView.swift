//  View/Grid&InstructionsView.swift

import SwiftUI

struct GridAndInstructionsView: View {
    /// Dependency injection: pass data in
    let tableCards: [CardSet]
    let hasGameStarted: Bool
    let isSelected: (CardSet) -> Bool
    let setEvalStatus: SetEvalStatus
    let namespace: Namespace.ID
    let onCardTap: (CardSet) -> Void

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

    // MARK: - Card Grid View

    private var cardGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 70))],
                spacing: 12
            ) {
                ForEach(tableCards) { card in
                    CardView(
                        card: card,
                        isSelected: viewModel.isSelected(card: card),
                        setEvalStatus: viewModel.setEvalStatus,
                        namespace: dealSpace
                    )
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .onTapGesture { viewModel.select(this: card) }
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.8).combined(
                                with: .opacity
                            ),
                            removal: .opacity
                        )
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .animation(
                .spring(response: 0.35, dampingFraction: 0.75),
                value: viewModel.tableCards
            )
            .environmentObject(viewModel)
        }
    }

    // MARK: - Instructions View

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
