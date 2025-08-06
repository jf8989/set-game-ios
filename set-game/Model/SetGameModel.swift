// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    private(set) var deck: [CardSet] = []
    private(set) var tableCards: [CardSet] = []
    private(set) var discardPile: [CardSet] = []
    private(set) var selectedCards: [CardSet] = []
    private(set) var cardEvalStatus: SetEvalStatus = .none
    private(set) var score: Int = 0

    init() {
        generateDeck()
    }

    // MARK: - Deck Creation and Game Reset

    mutating func generateDeck() {
        tableCards.removeAll()
        selectedCards.removeAll()
        discardPile.removeAll()
        cardEvalStatus = .none
        score = 0
        createDeckShuffleAndDeal()
    }

    /// Deals up to the specified number of cards from the deck to the table.
    mutating func dealCards(for count: Int) {
        let cardsToDeal = min(count, deck.count)
        if cardsToDeal > 0 {
            tableCards.append(contentsOf: deck.prefix(cardsToDeal))
            deck.removeFirst(cardsToDeal)
        }
    }

    /// Handles user selection and Set calculation logic.
    mutating func choose(this card: CardSet) {
        switch cardEvalStatus {

        // When existing selection IS a Set:
        case .found:
            guard selectedCards.count == 3 else { return }
            /// Discard cards by moving them to the pile
            handleMatchedCards(when: true)
            /// Morover, if the chosen card is on the table, select it.
            select(that: card)

        // When existing selection ISN'T a Set:
        case .fail:
            guard selectedCards.count == 3 else { return }
            /// Clear existing selection
            handleMatchedCards(when: false)
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
                    cardEvalStatus = .found
                    score += 3
                } else {
                    // If result is false:
                    cardEvalStatus = .fail
                    score -= 1
                }
            }
        }
    }

}

// MARK: - Helpers [ Evaluates if a card is a set ]

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

/// Creates and shuffles the full deck, then deals 12 cards
extension SetGameModel {
    private mutating func createDeckShuffleAndDeal() {
        deck = CardColor.allCases.flatMap { color in
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
        }.shuffled()
        dealInitialCards()
    }

    private mutating func dealInitialCards() {
        tableCards.append(contentsOf: deck.prefix(12))
        deck.removeFirst(12)
    }
}

/// Discards selected cards and moves them to discard pile
extension SetGameModel {
    private mutating func handleMatchedCards(when setFound: Bool) {
        guard setFound else {
            /// Reset state
            selectedCards.removeAll()
            cardEvalStatus = .none
            return
        }

        /// Add selected cards to discard pile
        discardPile.append(contentsOf: selectedCards)

        /// Remove selected cards from the table
        tableCards.removeAll { cardOnTable in
            selectedCards.contains(where: { $0.id == cardOnTable.id })
        }

        selectedCards.removeAll()
        cardEvalStatus = .none

    }
}

/// Selects the chosen card
extension SetGameModel {
    mutating func select(that card: CardSet) {
        guard tableCards.contains(where: { $0.id == card.id }) else { return }
        selectedCards.append(card)
    }
}
