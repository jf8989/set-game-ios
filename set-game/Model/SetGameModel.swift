// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    private(set) var deck: [SetCard] = []
    private(set) var tableCards: [SetCard] = []

    private(set) var selectedCardIDs = Set<UUID>()
    private(set) var showSetSuccess: Bool = false  // true when 3 selected cards ARE a set
    private(set) var showSetFail: Bool = false  // true when 3 selected cards ARE NOT a set

    // MARK: - *** DECK CREATION AND DEALING ***

    mutating func generateDeck() {
        deck = CardColor.allCases.flatMap { color in
            CardSymbol.allCases.flatMap { symbol in
                CardNumber.allCases.flatMap { number in
                    CardShading.allCases.map { shading in
                        SetCard(
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

        tableCards.removeAll()
        dealCards(for: 12)
    }

    mutating func dealCards(for dealCount: Int) {
        // If 3 matched cards are selected, replace them instead of adding new cards.
        if showSetSuccess {
            replaceMatchedCards()
            return
        }

        let cardsToDeal = min(dealCount, deck.count)
        if cardsToDeal > 0 {
            tableCards.append(contentsOf: deck.prefix(cardsToDeal))
            deck.removeFirst(cardsToDeal)
        }
    }

    // MARK: - *** CORE LOGIC ***

    mutating func toggleSelection(for card: SetCard) {
        // 1. Handle the tap AFTER a set has been identified.
        // If we've already found a successful set, this tap means "OK, I've seen it, move on."
        if showSetSuccess {
            replaceMatchedCards()  // Replace the matched cards.

            // If the user tapped a card that wasn't part of the matched set, select it.
            if !selectedCardIDs.contains(card.id)
                && tableCards.contains(where: { $0.id == card.id })
            {
                selectedCardIDs = [card.id]
            }
            return  // Done
        }

        // If we've already found a failed set, this tap deselects them and selects the new card.
        if showSetFail {
            selectedCardIDs.removeAll()
            selectedCardIDs.insert(card.id)
            showSetFail = false  // Reset the flag.
            return  // Done
        }

        // 2. Handle standard selection (fewer than 3 cards selected).
        // If the tapped card is already selected, deselect it.
        if selectedCardIDs.contains(card.id) {
            selectedCardIDs.remove(card.id)
        } else {
            // Otherwise, select it.
            selectedCardIDs.insert(card.id)
        }

        // 3. Check for a set ONLY when the 3rd card is selected.
        if selectedCardIDs.count == 3 {
            let selectedCards = tableCards.filter {
                selectedCardIDs.contains($0.id)
            }
            if isSet(cards: selectedCards) {
                // Set! Set success flag.
                showSetSuccess = true
            } else {
                // Mismatch. Set fail flag.
                showSetFail = true
            }
        }
    }

    // MARK: - *** HELPER FUNCTIONS (model-only methods) ***

    private mutating func replaceMatchedCards() {
        // Remove matched cards from the table.
        tableCards.removeAll { selectedCardIDs.contains($0.id) }

        // Deal 3 new cards from the deck.
        dealCards(for: 3)

        // Clear the selection and reset the flags.
        selectedCardIDs.removeAll()
        showSetSuccess = false
    }

    private func isSet(cards: [SetCard]) -> Bool {
        guard cards.count == 3 else { return false }

        // Fetch unique card's attributes.
        let colors = cards.map { $0.color }
        let symbols = cards.map { $0.symbol }
        let numbers = cards.map { $0.number.rawValue }
        let shadings = cards.map { $0.shading }

        // Perform Set evaluation logic.
        return allSameOrAllDifferent(colors)
            && allSameOrAllDifferent(symbols)
            && allSameOrAllDifferent(numbers)
            && allSameOrAllDifferent(shadings)
    }

    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let uniqueValues = Set(values)
        return uniqueValues.count == 1 || uniqueValues.count == 3
    }
}
