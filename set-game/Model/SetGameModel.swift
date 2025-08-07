// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    var deck: [CardSet] = []
    var tableCards: [CardSet] = []
    var discardPile: [CardSet] = []
    var selectedCards: [CardSet] = []
    var setEvalStatus: SetEvalStatus = .none
    var score: Int = 0

    init() {
        generateDeck()
    }

    // MARK: - Deck Creation and Game Reset

    mutating func generateDeck() {
        tableCards.removeAll()
        selectedCards.removeAll()
        discardPile.removeAll()
        setEvalStatus = .none
        score = 0
        createDeckShuffleAndDeal()
    }

    /// Deals up to the specified number of cards from the deck to the table.
    mutating func dealCards() {

        switch setEvalStatus {
        case .found: break
        case .fail:
            if cardsToDeal > 0 {
                tableCards.append(contentsOf: deck.prefix(cardsToDeal))
                deck.removeFirst(cardsToDeal)
            }
        case .none: break
        }

    }

    /// Handles user selection and Set calculation logic.
    mutating func choose(this card: CardSet) {
        switch setEvalStatus {

        // When existing selection IS a Set:
        case .found:
            guard selectedCards.count == 3 else { return }
            /// Discard cards by moving them to the pile
            handleThreeSelectedCards()
            /// Morover, if the chosen card is on the table, select it.
            select(that: card)

        // When existing selection ISN'T a Set:
        case .fail:
            guard selectedCards.count == 3 else { return }
            /// Clear existing selection
            handleThreeSelectedCards()
            /// Select chosen card
            select(that: card)

        // Normal selection:
        case .none:
            /// If user taps on a selected card, deselect it.
            if let index = selectedCards.firstIndex(where: { $0.id == card.id })
            {
                selectedCards.remove(at: index)
            } else if selectedCards.count < 3 {
                select(that: card)
            }

            /// Evaluate the selected set:
            if selectedCards.count == 3 {
                // If result is true:
                if isSet(cards: selectedCards) {
                    setEvalStatus = .found
                    score += 3
                } else {
                    // If result is false:
                    setEvalStatus = .fail
                    score -= 1
                }
            }
        }
    }

}

// MARK: - Helpers

/// Evaluates if a card is a set
extension SetGameModel {
    private func isSet(cards: [CardSet]) -> Bool {
        guard cards.count == 3 else { return false }
        let colors = cards.map { $0.color }
        let symbols = cards.map { $0.symbol }
        let numbers = cards.map { $0.number.rawValue }
        let shadings = cards.map { $0.shading }

        return allSameOrAllDifferent(colors)
            && allSameOrAllDifferent(symbols)
            && allSameOrAllDifferent(numbers)
            && allSameOrAllDifferent(shadings)
    }

    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let unique = Set(values)
        return unique.count == 1 || unique.count == 3
    }
}

/// Discards selected cards and moves them to discard pile based on Set evaluation
extension SetGameModel {
    private mutating func handleThreeSelectedCards() {
        guard setEvalStatus == .found else {
            /// Reset state
            selectedCards.removeAll()
            setEvalStatus = .none
            return
        }

        /// Add selected cards to discard pile
        discardPile.append(contentsOf: selectedCards)

        /// Remove selected cards from the table
        tableCards.removeAll { cardOnTable in
            selectedCards.contains(where: { $0.id == cardOnTable.id })
        }

        selectedCards.removeAll()
        setEvalStatus = .none

    }
}

/// Selects the chosen card
extension SetGameModel {
    private mutating func select(that card: CardSet) {
        guard tableCards.contains(where: { $0.id == card.id }) else { return }
        selectedCards.append(card)
    }
}

extension SetGameModel {
    private mutating func normalDraw() {
        let cardsToDeal = min(3, deck.count)

        if cardsToDeal > 0 {
            tableCards.append(contentsOf: deck.prefix(cardsToDeal))
            deck.removeFirst(cardsToDeal)
        }
    }

    private mutating func drawAndReplaceMatched() {

    }
}
