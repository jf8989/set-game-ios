// View/SetGameView.swift

import SwiftUI

struct SetGameView: View {

    // MARK: - State Properties

    @StateObject private var viewModel = SetGameViewModel()
    @Namespace private var dealSpace
    @State private(set) var hasGameStarted = false

    // MARK: - Computed Properties (Child Views)

    private var headerView: some View {
        HeaderView(
            score: viewModel.score,
            cardsLeft: viewModel.cardsLeft,
            hasGameStarted: hasGameStarted
        )
    }

    private var centerView: some View {
        GridAndInstructionsView(
            tableCards: viewModel.tableCards,
            hasGameStarted: hasGameStarted,
            isSelected: { viewModel.isSelected(card: $0) },
            setEvalStatus: viewModel.setEvalStatus,
            namespace: dealSpace,
            select: { viewModel.select(this: $0) }
        )
    }

    private var actionButtons: some View {
        ActionButtonsView(
            hasGameStarted: hasGameStarted,
            startNewGame: { viewModel.startNewGame() },
            dealThreeMore: { viewModel.dealThreeMore() },
            isDeckEmpty: viewModel.isDeckEmpty,
            onStartGame: { hasGameStarted.toggle() }  // flip bool in closure
        )
    }

    // MARK: - Main Body View

    var body: some View {
        VStack {
            headerView
            Spacer()
            centerView
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
