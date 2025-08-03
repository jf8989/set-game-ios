// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    private(set) var deck: [SetCard] = []
    private(set) var tableCards: [SetCard] = []
    private(set) var selectedCardIDs = Set<UUID>()
    private(set) var selectionStatus: SetSelectionStatus = .none
    private(set) var score: Int = 0

    // MARK: - Deck Creation and Game Reset

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
        selectedCardIDs.removeAll()
        selectionStatus = .none
        dealCards(for: 12)
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
    mutating func toggleSelection(for card: SetCard) {
        // If a Set was just found, remove and replace, then handle new selection.
        if selectionStatus == .found {
            tableCards.removeAll { selectedCardIDs.contains($0.id) }
            selectedCardIDs.removeAll()
            selectionStatus = .none
            dealCards(for: 3)
            // Select card if still present on table because this is a new selection attempt.
            if tableCards.contains(where: { $0.id == card.id }) {
                selectedCardIDs.insert(card.id)
            }
            return
        }

        // If last selection was a failed Set, deselect all and select the tapped card.
        if selectionStatus == .fail {
            selectedCardIDs.removeAll()
            selectedCardIDs.insert(card.id)
            selectionStatus = .none
            return
        }

        // Standard select/deselect logic before we even evaluate if it's a set.
        // When the user wants to deselect a card:
        if selectedCardIDs.contains(card.id) {
            selectedCardIDs.remove(card.id)
        } else {
            // When the user selects a new card. (not yet 3)
            selectedCardIDs.insert(card.id)
        }

        // Only check for Set if exactly 3 selected.
        if selectedCardIDs.count == 3 {
            // Find the selected cards on the table by ID.
            let selectedCards = tableCards.filter {
                selectedCardIDs.contains($0.id)
            }
            // Send them for evaluation.
            // If this returns true:
            if isSet(cards: selectedCards) {
                selectionStatus = .found
                score += 3
                //                print("This is a SET!: TRUE")
            } else {
                selectionStatus = .fail
                score -= 1
                //                print("This is NOT a SET!: FALSE")
            }
        } else {
            selectionStatus = .none
        }
    }

    // MARK: - Helpers

    private func isSet(cards: [SetCard]) -> Bool {
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
