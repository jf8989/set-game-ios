// View/SetGameView.swift

import SwiftUI

// MARK: - Top-level screen

struct SetGameView: View {
    @StateObject private var viewModel = SetGameViewModel()
    @Namespace private var dealSpace
    @State private var showInstructions = true
    @State private var showScore = false

    // Computed properties

    private var gameHeader: some View {
        HStack {
            score
            Spacer()
            gameTitle
            Spacer()
        }
    }

    @ViewBuilder
    private var score: some View {
        if viewModel.hasStarted {
            Text("Score: \(viewModel.score)")
                .font(.title2)
                .padding(.top)
        }
    }

    private var gameTitle: some View {
        Text("Set Game")
            .font(.largeTitle)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.top)
    }

    private var gameInstructions: some View {
        VStack(spacing: 8) {
            if !viewModel.hasStarted {
                Spacer()
                Text("How to Play:")
                    .font(.headline)
                Text(
                    """
                    - Select 3 cards you think form a Set.
                    - A Set means each property (color, symbol, shading, number) is all the same or all different.
                    - Tap to select/deselect. After 3 cards, see if you found a Set!
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

    private var cardGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 70))],
                spacing: 12
            ) {
                ForEach(viewModel.tableCards) { card in
                    CardView(
                        card: card,
                        isSelected: viewModel.selectedCardIDs.contains(card.id),
                        selectionStatus: viewModel.selectionStatus,
                        namespace: dealSpace
                    )
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .onTapGesture { viewModel.selectCard(card) }
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

    private var actionButtons: some View {
        HStack(spacing: 22) {
            Button("New Game") {
                withAnimation { viewModel.startNewGame() }
                showInstructions = false
                showScore = true
            }
            Button("Deal 3 More") {
                withAnimation { viewModel.dealThreeMore() }
            }
            .disabled(viewModel.isDeckEmpty)
        }
        .font(.title2)
        .padding(.bottom, 10)
    }

    // MAIN BODY

    var body: some View {
        VStack {
            gameHeader
            gameInstructions
            cardGrid
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
