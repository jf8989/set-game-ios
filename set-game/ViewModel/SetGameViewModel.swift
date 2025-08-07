// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    // When the model changes, the view will be notified.
    @Published private var game = SetGame()

    // MARK: - Model Accessors (View State)

    /// The View can read these properties to know how to draw itself.

    var deck: [CardSet] { game.deck }

    var tableCards: [CardSet] { game.tableCards }

    var discardPile: [CardSet] { game.discardPile }

    var selectedCards: [CardSet] { game.selectedCards }

    var setEvalStatus: SetEvalStatus { game.setEvalStatus }

    var isDeckEmpty: Bool { game.deck.isEmpty }

    var score: Int { game.score }

    var cardsLeft: Int { game.deck.count }

    // MARK: - View Helper Methods

    /// Calculates if a tapped card is actually selected
    func isSelected(card: CardSet) -> Bool {
        game.selectedCards.contains { $0.id == card.id }
    }

    /// Interprets the right model color for the view
    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }

    // MARK: - User Intents

    /// Creates a brand-new instance of the model to guarantee FULL RESET
    func startNewGame() {
        game = SetGame()
    }

    /// Passes the user's choice to the model.
    func select(this card: CardSet) {
        game.choose(this: card)
    }

    /// Tells the model to deal more cards.
    func dealThreeMore() {
        game.dealCards()
    }

    /// Shuffles visible cards
    func shuffleTableCards() {
        game.shuffleTableCards()
    }

}
