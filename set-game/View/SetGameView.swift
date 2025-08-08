// View/SetGameView.swift

import SwiftUI

struct SetGameView: View {

    // MARK: - State Properties

    @StateObject private var viewModel = SetGameViewModel()
    @Namespace private var dealSpace
    @State private(set) var hasGameStarted = false

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

    // MARK: - Card Grid View

    private var cardGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 70))],
                spacing: 12
            ) {
                ForEach(viewModel.tableCards) { card in
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

    // MARK: - Action Buttons View

    private var actionButtons: some View {
        HStack(spacing: 22) {
            if hasGameStarted {
                Button("New Game") {
                    withAnimation { viewModel.startNewGame() }
                }
                Button("Deal 3 More") {
                    withAnimation { viewModel.dealThreeMore() }
                }
                .disabled(viewModel.isDeckEmpty)
            }
            if !hasGameStarted {
                Button("Get Started!") {
                    withAnimation {
                        hasGameStarted.toggle()
                    }
                }
            }
        }.font(.title2)
            .padding(.bottom, 10)
    }

    // MARK: - Main Body View

    var body: some View {
        VStack {
            HeaderView(
                score: viewModel.score,
                cardsLeft: viewModel.cardsLeft,
                hasGameStarted: hasGameStarted
            )
            Spacer()
            mainView
            Spacer()
            actionButtons
        }
    }
}

// MARK: - Preview

#Preview {
    SetGameView()
        .environmentObject(SetGameViewModel())
}
