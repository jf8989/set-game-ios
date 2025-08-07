// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

// MARK: - Main ViewModel Body

class SetGameViewModel: ObservableObject {
    // When the model changes, the view will be notified.
    @Published private var model = SetGameModel()

    // MARK: - User Intent Functions

    // Creates a new model and starts the game.
    func startNewGame() {
        model = SetGameModel()
        model.generateDeck()
    }

    // Passes the user's choice to the model.
    func selectCard(_ card: CardSet) {
        model.choose(this: card)
    }

    // Tells the model to deal more cards.
    func dealThreeMore() {
        model.dealCards()
    }

}

// MARK: - Color Properties

extension SetGameViewModel {
    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
}

// MARK: - Reactive State Properties

extension SetGameViewModel {
    // The View can read these properties to know how to draw itself.
    var deck: [CardSet] { model.deck }

    var tableCards: [CardSet] { model.tableCards }

    var discardPile: [CardSet] { model.discardPile }

    var hasStarted: Bool { !tableCards.isEmpty }

    var selectedCardIDs: [CardSet] { model.selectedCards }

    var setEvalStatus: SetEvalStatus { model.setEvalStatus }

    var isDeckEmpty: Bool { model.deck.isEmpty }

    var score: Int { model.score }

    var cardsLeft: Int { model.deck.count }
}
