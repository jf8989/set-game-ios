// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

// MARK: - Main ViewModel Body

class SetGameViewModel: ObservableObject {
    // When the model changes, the view will be notified.
    @Published private var model = SetGameModel()

    // MARK: - Model Accessors (View State)

    // The View can read these properties to know how to draw itself.
    var deck: [CardSet] { model.deck }

    var tableCards: [CardSet] { model.tableCards }

    var discardPile: [CardSet] { model.discardPile }

    var selectedCards: [CardSet] { model.selectedCards }

    var setEvalStatus: SetEvalStatus { model.setEvalStatus }

    var isDeckEmpty: Bool { model.deck.isEmpty }

    var score: Int { model.score }

    var cardsLeft: Int { model.deck.count }

    // MARK: - View Helper Methods

    /// Creates a brand-new instance of the model to guarantee FULL RESET
    func isSelected(card: CardSet) -> Bool {
        model.selectedCards.contains { $0.id == card.id }
    }

    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }

    // MARK: - User Intents

    // Creates a new model and starts the game.
    func startNewGame() {
        model = SetGameModel()
    }

    // Passes the user's choice to the model.
    func select(this card: CardSet) {
        model.choose(this: card)
    }

    // Tells the model to deal more cards.
    func dealThreeMore() {
        model.dealCards()
    }

    func shuffleTableCards() {
        model.shuffleTableCards()
    }

}
