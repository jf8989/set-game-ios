// Engine/SetGame.swift

import Foundation

/// Main rules for the Set card game.

struct SetGame {
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

    // MARK: - Deck Creation and Game Reset

    /// Regenerates and shuffles the deck, resets all game state.
    mutating func generateDeck() {
        tableCards.removeAll()
        selectedCards.removeAll()
        discardPile.removeAll()
        setEvalStatus = .none
        score = 0
        deck = DeckFactory.createShuffledDeck()
        dealInitialCards()
    }

    // MARK: - Dealing Logic

    /// Deals up to the specified number of cards from the deck to the table.
    mutating func dealCards() {

        switch setEvalStatus {
        case .found: drawAndReplaceMatchedCards()
        case .fail: normalDraw()
        case .none: normalDraw()

        }
    }

    // MARK: - Selection Logic

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
                if selectedCards.isSet {
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

    // MARK: - Shuffle Logic

    mutating func shuffleTableCards() {
        tableCards.shuffle()
    }

}

// MARK: - Deck Management Helpers

/// Creates and shuffles the full deck, then deals 12 cards
extension SetGame {
    mutating func dealInitialCards() {
        tableCards.append(contentsOf: deck.prefix(12))
        deck.removeFirst(12)
    }
}

// MARK: - Selection/Discard Helpers

extension SetGame {
    /// Discards selected cards and moves them to discard pile based on Set evaluation
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

        clearSelection()
    }

    /// Selects the chosen card
    private mutating func select(that card: CardSet) {
        guard tableCards.contains(where: { $0.id == card.id }) else { return }
        selectedCards.append(card)
    }

    /// Clears selection
    private mutating func clearSelection() {
        selectedCards.removeAll()
        setEvalStatus = .none
    }
}

// MARK: - Draw Helpers

extension SetGame {
    ///  Appends cards to the table.
    private mutating func normalDraw() {
        let cardsToDeal = min(3, deck.count)

        if cardsToDeal > 0 {
            tableCards.append(contentsOf: deck.prefix(cardsToDeal))
            deck.removeFirst(cardsToDeal)
        }
    }

    /// Finds the indices of the 3 matched cards on the table.
    private mutating func drawAndReplaceMatchedCards() {
        /// 1. Purposely renames my card reference for the current intent.
        let cardsToReplace: [CardSet] = selectedCards

        /// 2. Finds the indices of the matched cards on the table.
        let matchedIndices = cardsToReplace.compactMap { matchedCard in
            tableCards.firstIndex(where: { $0.id == matchedCard.id })
        }

        /// 3. Replaces cards at those indices with new ones from the deck.
        for index in matchedIndices {
            if !deck.isEmpty {
                tableCards[index] = deck.removeFirst()
            }
        }

        /// In case the deck is empty, makes sure to remove the remaining selected cards from the table.
        tableCards.removeAll { cardOnTable in
            cardsToReplace.contains(where: { $0.id == cardOnTable.id })
        }

        /// 4. Moves the selected cards to the discard pile.
        discardPile.append(contentsOf: cardsToReplace)

        /// 5. Clears selection.
        clearSelection()
    }
}
