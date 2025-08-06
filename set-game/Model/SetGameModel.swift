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
    mutating func toggleSelection(for card: CardSet) {
        // When existing selection IS a Set:
        if cardEvalStatus == .found {
            /// Move selected cards to discardPile array
            let matchedCards = tableCards.filter {
                selectedCards.contains($0.id)
            }
            discardPile.append(contentsOf: matchedCards)
            tableCards.removeAll { selectedCards.contains($0.id) }
            /// Clear selection
            selectedCards.removeAll()
            cardEvalStatus = .none
            // Select card if still present on table because this is a new selection attempt.
            if tableCards.contains(where: { $0.id == card.id }) {
                selectedCards.insert(card.id)
            }
            return
        }

        // If last selection was a failed Set, deselect all and select the tapped card.
        if cardEvalStatus == .fail {
            selectedCards.removeAll()
            selectedCards.insert(card.id)
            cardEvalStatus = .none
            return
        }

        // Standard select/deselect logic before we even evaluate if it's a set.
        // When the user wants to deselect a card:
        if selectedCards.contains(card.id) {
            selectedCards.remove(card.id)
        } else {
            // When the user selects a new card. (not yet 3)
            selectedCards.insert(card.id)
        }

        // Only check for Set if exactly 3 selected.
        if selectedCards.count == 3 {
            // Find the selected cards on the table by ID.
            let selectedCards = tableCards.filter {
                selectedCards.contains($0.id)
            }
            // Send them for evaluation.
            // If this returns true:
            if isSet(cards: selectedCards) {
                cardEvalStatus = .found
                score += 3
                //                print("This is a SET!: TRUE")
            } else {
                cardEvalStatus = .fail
                score -= 1
                //                print("This is NOT a SET!: FALSE")
            }
        } else {
            cardEvalStatus = .none
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
