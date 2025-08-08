// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    // When the model changes, the view will be notified.
    @Published private var game = SetGame()

    /// This is the key to the solution. It's a state property managed by the ViewModel
    /// to orchestrate the discard animation. It holds cards that are "in flight"
    /// from the table to the discard pile.
    @Published private var cardsInFlight: [CardSet] = []

    // MARK: - Model Accessors (View State)

    /// The View can read these properties to know how to draw itself.

    var deck: [CardSet] { game.deck }

    /// This is a crucial modification. The View's grid of cards is now filtered.
    /// It hides any card that is currently "in flight", making it disappear from the grid.
    /// This is what triggers the `matchedGeometryEffect` to animate it to its new location.
    var tableCards: [CardSet] {
        game.tableCards.filter { card in
            !cardsInFlight.contains(where: { $0.id == card.id })
        }
    }

    var discardPile: [CardSet] { game.discardPile + cardsInFlight }

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
        // It checks if a set was matched *before* the model state changes.
        let matchedCards =
            game.setEvalStatus == .found ? game.selectedCards : []

        // It tells the Model to apply its rules. The Model changes its state instantly.
        game.choose(this: card)

        // Checks if a discard occured.
        if !matchedCards.isEmpty {
            // Puts the matched cards in a flying state.
            cardsInFlight.append(contentsOf: matchedCards)

            // It schedules the final state update for after the animation is visually complete.
            // This is the hand-off from the ViewModel's animation state to the Model's final state.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // It removes the cards from the "in-flight" state, as they have now
                // "landed" in the model's actual discard pile.
                self.cardsInFlight.removeAll { cardToRemove in
                    matchedCards.contains(where: { $0.id == cardToRemove.id })
                }
            }
        }
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
