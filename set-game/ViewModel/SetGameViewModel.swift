// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    // When the model changes, the view will be notified.
    @Published private var model = SetGameModel()

    // MARK: - User Intents

    // Creates a new model and starts the game.
    func startNewGame() {
        model = SetGameModel()
        model.generateDeck()
    }

    // Passes the user's choice to the model.
    func selectCard(_ card: CardSet) {
        model.toggleSelection(for: card)
    }

    // Tells the model to deal more cards.
    func dealThreeMore() {
        model.dealCards(for: 3)
    }

}

// MARK: - Properties for the View to Read
extension SetGameViewModel {
    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
}

extension SetGameViewModel {
    // The View can read these properties to know how to draw itself.
    var tableCards: [CardSet] {
        model.tableCards
    }

    var hasStarted: Bool {
        !tableCards.isEmpty
    }

    var selectedCardIDs: Set<UUID> {
        model.selectedCardIDs
    }

    var setEvalStatus: SetEvalStatus { model.cardEvalStatus }

    var isDeckEmpty: Bool {
        model.deck.isEmpty
    }

    var score: Int { model.score }

    var cardsLeft: Int { model.deck.count }
}
