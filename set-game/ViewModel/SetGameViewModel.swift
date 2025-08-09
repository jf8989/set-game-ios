// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    // MARK: - Model
    /// He's publishing the entire game model. Any change to the game state will trigger a UI update.
    @Published private var game = SetGame()

    // MARK: - Animation-Specific State
    /// He's using this temporary array to hold cards for the initial dealing animation.
    @Published private var stagedForInitialDeal: [CardSet] = []

    /// He's using a unique ID to ensure that only the most recent "New Game" animation runs.
    private var initialDealSession = UUID()
    private let initialDealStep: Double = 0.08
    private let initialDealAnim: Double = 0.35

    // MARK: - Computed Properties for the View

    /// He's combining the model's deck with the staged cards so the View sees a single source for the deck pile.
    var deckDisplay: [CardSet] { game.deck + stagedForInitialDeal }

    /// He's exposing the model's table cards directly to the View.
    var tableCards: [CardSet] { game.tableCards }

    /// He's exposing the model's discard pile directly. This fixed the bug where the discard pile view wasn't updating.
    var discardPile: [CardSet] { game.discardPile }

    // MARK: Passthrough properties

    /// He's providing direct, read-only access to specific model properties for the View's convenience.
    var deck: [CardSet] { game.deck }
    var selectedCards: [CardSet] { game.selectedCards }
    var setEvalStatus: SetEvalStatus { game.setEvalStatus }
    var isDeckEmpty: Bool { game.deck.isEmpty }
    var score: Int { game.score }
    var cardsLeft: Int { game.deck.count }

    // MARK: - View Helper Methods

    /// He's providing a helper function to check if a card is selected, keeping this logic out of the View.
    func isSelected(card: CardSet) -> Bool {
        game.selectedCards.contains { $0.id == card.id }
    }

    /// He's centralizing the color mapping logic here so the View doesn't need to know about the model's enums.
    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }

    // MARK: - User Intents

    /// He's orchestrating the start of a new game, including the staggered dealing animation.
    func startNewGame() {
        let session = UUID()
        initialDealSession = session
        game = SetGame()
        let initial12 = game.tableCards
        game.tableCards.removeAll()
        stagedForInitialDeal = initial12
        for (i, card) in initial12.enumerated() {
            let delay = Double(i) * initialDealStep
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                [weak self] in
                guard let self, self.initialDealSession == session else {
                    return
                }
                withAnimation(.easeInOut(duration: self.initialDealAnim)) {
                    self.game.tableCards.append(card)
                    self.stagedForInitialDeal.removeAll { $0.id == card.id }
                }
            }
        }
    }

    /// He's passing the user's selection directly to the model. The ViewModel's job is just to translate the intent.
    func select(this card: CardSet) {
        game.choose(this: card)
    }

    /// He's passing the deal intent to the model. The animation is handled by the View's `withAnimation` block.
    func dealThreeMore() {
        game.dealCards()
    }

    /// He's passing the shuffle intent to the model.
    func shuffleTableCards() {
        game.shuffleTableCards()
    }
}
