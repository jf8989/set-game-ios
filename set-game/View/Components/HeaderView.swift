//  View/Sub-View/HeaderView.swift

import SwiftUI

struct HeaderView: View {
    /// Dependency injection: pass data in
    let score: Int
    let cardsLeft: Int
    let hasGameStarted: Bool

    // MARK: - Body View

    var body: some View {
        gameHeader
    }

    // MARK: - Header View

    private var gameHeader: some View {
        VStack(spacing: 0) {
            HStack {
                scoreView
                Spacer()
                cardsLeftView
            }
            gameTitle
        }
    }

    // MARK: - Sub.Views

    @ViewBuilder
    private var scoreView: some View {
        if hasGameStarted {
            Text("Score: \(score)")
                .font(.title2)
                .padding(.trailing)
        }
    }

    @ViewBuilder
    private var cardsLeftView: some View {
        if hasGameStarted {
            Text("Cards left: \(cardsLeft)")
                .font(.title2)
                .padding(.trailing)
        }
    }

    private var gameTitle: some View {
        Text("Set Game")
            .font(.largeTitle)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.top)
    }
}
