// Core/Engine/SetGame.swift

import Foundation

/// Main rules for the Set card game.
struct SetGameRules {
    // MARK: - Properties
    var deck: [CardSet] = []
    var tableCards: [CardSet] = []
    var discardPile: [CardSet] = []
    var selectedCards: [CardSet] = []
    var setEvalStatus: SetEvalStatus = .none
    var score: Int = 0

    // MARK: - Initialization
    init() {
        generateDeck()
    }

    // MARK: - Game State
    /// My function to reset the game to a fresh state.
    mutating func generateDeck() {
        tableCards.removeAll()
        selectedCards.removeAll()
        discardPile.removeAll()
        setEvalStatus = .none
        score = 0
        deck = createShuffledDeck()
        dealInitialCards()
    }

    mutating func dealCards() {
        // If my user found a set, I'll replace those cards instead of adding 3 more.
        if setEvalStatus == .found {
            drawAndReplaceMatchedCards()
        } else {
            normalDraw()
        }
    }

    mutating func shuffleTableCards() {
        tableCards.shuffle()
    }

    // MARK: - Core Selection Logic
    /// My core selection logic
    mutating func choose(this card: CardSet) {
        switch setEvalStatus {
        case .found:
            // My user tapped while a matched set was showing.
            // I'll process that set and this tap is now "consumed".
            drawAndReplaceMatchedCards()

        case .fail:
            // User tapped after a failed match.
            // I'll clear the old selection and start a new one with the tapped card.
            selectedCards.removeAll()
            setEvalStatus = .none

        case .none:
            // This is my normal selection flow.
            if let index = selectedCards.firstIndex(where: { $0.id == card.id }) {
                // The user tapped an already selected card, so I'll deselect it.
                selectedCards.remove(at: index)
            } else if selectedCards.count < SetGameRules.Rules.selectionTargetCount {
                // The user tapped a new card, so I'll add it to the selection.
                selectedCards.append(card)
            }

            // I'll evaluate for a set only when my user has picked exactly N cards.
            if selectedCards.count == SetGameRules.Rules.selectionTargetCount {
                if selectedCards.isSet {
                    setEvalStatus = .found
                    score += SetGameRules.Rules.matchScoreReward
                } else {
                    setEvalStatus = .fail
                    score -= SetGameRules.Rules.mismatchScorePenalty
                }
            }
        }
    }
}

// MARK: - Card Dealing Helpers Ext.
extension SetGameRules {
    /// My helper to deal the initial N cards at the start of the game.
    mutating func dealInitialCards() {
        tableCards.append(contentsOf: deck.prefix(SetGameRules.Rules.initialDealCount))
        deck.removeFirst(SetGameRules.Rules.initialDealCount)
    }

    /// My helper for a standard deal batch.
    private mutating func normalDraw() {
        let cardsToDeal = min(SetGameRules.Rules.dealBatchCount, deck.count)
        if cardsToDeal > 0 {
            tableCards.append(contentsOf: deck.prefix(cardsToDeal))
            deck.removeFirst(cardsToDeal)
        }
    }

    /// My consolidated function to process a matched set.
    private mutating func drawAndReplaceMatchedCards() {
        let cardsToReplace = selectedCards

        // First, I'll move the matched cards to the discard pile for the View to see.
        discardPile.append(contentsOf: cardsToReplace)

        // If my deck still has cards, I'll replace the matched ones on the table.
        if !deck.isEmpty {
            let matchedIndices = cardsToReplace.compactMap { matchedCard in
                tableCards.firstIndex(where: { $0.id == matchedCard.id })
            }
            for index in matchedIndices {
                tableCards[index] = deck.removeFirst()
            }
        } else {
            // If my deck is empty, I'll just remove the matched cards.
            tableCards.removeAll { cardOnTable in
                cardsToReplace.contains(where: { $0.id == cardOnTable.id })
            }
        }

        // Finally, I'll reset the selection state.
        selectedCards.removeAll()
        setEvalStatus = .none
    }
}

// MARK: - Deck Factory Helper Ext.

extension SetGameRules {
    func createShuffledDeck() -> [CardSet] {
        CardColor.allCases.flatMap { color in
            CardSymbol.allCases.flatMap { symbol in
                CardNumber.allCases.flatMap { number in
                    CardShading.allCases.map { shading in
                        CardSet(
                            id: UUID(),
                            color: color,
                            symbol: symbol,
                            shading: shading,
                            number: number
                        )
                    }
                }
            }
        }
        .shuffled()
    }
}

// MARK: - Game Rules Ext.
extension SetGameRules {
    enum Rules {
        /// Initial cards on table at game start.
        static let initialDealCount: Int = 12

        /// Cards dealt per “+3” action when no pending match.
        static let dealBatchCount: Int = 3

        /// Number of selections required to evaluate a set.
        static let selectionTargetCount: Int = 3

        /// Score delta when a set is found.
        static let matchScoreReward: Int = 3

        /// Score delta when selection is not a set.
        static let mismatchScorePenalty: Int = 1
    }
}
