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

    /// Temporary staging for initial 12 cards so they can "fly" from the deck on New Game.
    @Published private var stagedForInitialDeal: [CardSet] = []

    /// Internal guard to prevent overlapping initial-deal animations.
    private var initialDealSession = UUID()

    /// Tunables for the sequential initial deal animation.
    private let initialDealStep: Double = 0.08  // seconds between cards
    private let initialDealAnim: Double = 0.35  // duration of each flight

    // MARK: - Model Accessors (View State)

    /// The View can read these properties to know how to draw itself.

    var deck: [CardSet] { game.deck }

    /// Deck **display** = actual undealt deck + the 12 staged "ghosts" (sources for flight)
    var deckDisplay: [CardSet] { game.deck + stagedForInitialDeal }

    var tableCards: [CardSet] {
        /// Keep a ghost on the grid for in-flight cards so matchedGeometryEffect has a source.
        let extras = cardsInFlight.filter { inflight in
            !game.tableCards.contains(where: { $0.id == inflight.id })
        }
        return game.tableCards + extras
    }

    var discardPile: [CardSet] {
        /// Ensure a single destination per id (no duplicates: either in-flight OR settled).
        let inflightIDs = Set(cardsInFlight.map(\.id))
        let settled = game.discardPile.filter { !inflightIDs.contains($0.id) }
        return settled + cardsInFlight
    }

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

        // Capture the model's initially dealt 12 (destination set)
        let initial12 = game.tableCards

        // 1) Grid must start EMPTY so cards appear one-by-one.
        game.tableCards.removeAll()

        // 2) Stage those 12 as "deck ghosts" (sources for matchedGeometryEffect).
        stagedForInitialDeal = initial12

        // 3) Sequentially append to grid + remove ghost in the SAME animation,
        //    so the card *flies* from deck → its seat.
        let session = UUID()
        initialDealSession = session

        for (i, card) in initial12.enumerated() {
            let delay = Double(i) * initialDealStep
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                [weak self] in
                guard let self, self.initialDealSession == session else {
                    return
                }
                withAnimation(.easeInOut(duration: self.initialDealAnim)) {
                    // Destination appears:
                    self.game.tableCards.append(card)
                    // Source disappears:
                    self.stagedForInitialDeal.removeAll { $0.id == card.id }
                }
                // Logging in third person
                print("ViewModel deals initial card \(i+1)/\(initial12.count)")
            }
        }
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

    // MARK: - Helper Methods

    /// Calculates if card is currently animating to the discard pile
    func isInFlight(_ card: CardSet) -> Bool {
        cardsInFlight.contains { $0.id == card.id }
    }

}
