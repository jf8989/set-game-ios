// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    // MARK: - Model
    @Published private var game = SetGame()

    // MARK: - Animation-Specific State

    /// This is for the initial deal.
    @Published private var stagedForInitialDeal: [CardSet] = []

    /// This is the ViewModel's permanent, visible discard pile.
    /// In this reverted state, it's not being updated correctly for animation.
    @Published private var discardDisplay: [CardSet] = []

    private var initialDealSession = UUID()
    private let initialDealStep: Double = 0.08
    private let initialDealAnim: Double = 0.35

    // MARK: - Computed Properties for the View

    /// The deck the View sees includes the real deck PLUS any cards staged for the initial deal.
    var deckDisplay: [CardSet] { game.deck + stagedForInitialDeal }

    /// The table cards are read directly from the model.
    var tableCards: [CardSet] { game.tableCards }

    /// The discard pile is read from the ViewModel's display array.
    var discardPile: [CardSet] { discardDisplay }

    // Passthrough properties
    var deck: [CardSet] { game.deck }
    var selectedCards: [CardSet] { game.selectedCards }
    var setEvalStatus: SetEvalStatus { game.setEvalStatus }
    var isDeckEmpty: Bool { game.deck.isEmpty }
    var score: Int { game.score }
    var cardsLeft: Int { game.deck.count }

    // MARK: - View Helper Methods
    func isSelected(card: CardSet) -> Bool {
        game.selectedCards.contains { $0.id == card.id }
    }
    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }

    // MARK: - User Intents

    func startNewGame() {
        let session = UUID()
        initialDealSession = session

        game = SetGame()
        discardDisplay.removeAll()

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

    func select(this card: CardSet) {
        game.choose(this: card)
    }

    func dealThreeMore() {
        game.dealCards()
    }

    func shuffleTableCards() {
        game.shuffleTableCards()
    }
}
