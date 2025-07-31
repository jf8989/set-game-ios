// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    private(set) var deck: [SetCard] = []
    private(set) var selectedCardIDs = Set<UUID>()
    private(set) var tableCards: [SetCard] = []

    // *** FUNCTIONS ***

    // Creates the deck by iterating through all cases and appending each unique card to the "deck" array.
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

        tableCards.removeAll()  // reset the table
        dealCards(for: 12)  // deal 12 cards at game start
    }

    // Deals cards when called at any given time
    mutating func dealCards(for dealCount: Int) {
        if dealCount <= 0 { return print("Incorrect deal count: \(dealCount)") }  // ignore bad calls
        guard deck.count >= dealCount else {
            // Deal whatever's left even if we're requesting more than what's available.
            tableCards.append(contentsOf: deck)
            deck.removeAll()
            print("No more cards left in deck.")
            return
        }
        tableCards.append(contentsOf: deck.prefix(dealCount))  // makes a simple copy of next cards in the deck
        deck.removeFirst(dealCount)  // removes those copies from the deck to avoid duplicates
        print(
            "Added \(dealCount) cards to the table: \(tableCards.suffix(dealCount))"
        )
        print("Deck now has \(deck.count) cards left.")
    }

    // Handles card selection
    mutating func toggleSelection(for card: SetCard) {
        // First, check context before doing anything else.
        if selectedCardIDs.contains(card.id) {  // If the card's already there, deselect it.
            // deselect it
            selectedCardIDs.remove(card.id)
            print("--Deselected card:", card)
        } else if selectedCardIDs.count < 3 {  // If we have less than 3 elements, it's a normal selection
            // select it
            selectedCardIDs.insert(card.id)
            print("**Selected card:", card)
        } else {
            print("--Already 3 selected.")
        }

        // Log current selection
        print("---Selected IDs:", selectedCardIDs)

        // When 3 unique cards are selected
        if selectedCardIDs.count == 3 {
            // Find the selected cards in the deck and use them
            let selectedCards = tableCards.filter {
                selectedCardIDs.contains($0.id)
            }
            if selectedCards.count != selectedCardIDs.count {
                print(
                    "These IDs were not found in the deck:",
                    selectedCardIDs,
                    "\n"
                )
            }
            // as long as selectedCards has 3 elements, we're good to go
            if selectedCards.count == 3 {
                let isASet = isSet(
                    card1: selectedCards[0],
                    card2: selectedCards[1],
                    card3: selectedCards[2]
                )

                if isASet {  // If the cards form a set:
                    tableCards.removeAll { selectedCardIDs.contains($0.id) }  // 1. Remove selected cards from the table.
                    print("*****This IS a set. \(isASet)")
                    if !deck.isEmpty {  // 2. If deck's not empty, deal 3 more cards to table
                        dealCards(for: 3)
                    }
                    selectedCardIDs.removeAll()  // 3. Forget selected cards. Ready for next selection batch.
                } else {  // If they're not a set:
                    print("*****This is NOT a set. \(isASet)")
                }
            }
        }
    }

    // Fetch the three cards and their individual attributes for evaluation.
    func isSet(card1: SetCard, card2: SetCard, card3: SetCard) -> Bool {
        let colors = [card1.color, card2.color, card3.color]
        let symbols = [card1.symbol, card2.symbol, card3.symbol]
        let numbers = [card1.number, card2.number, card3.number]
        let shadings = [card1.shading, card2.shading, card3.shading]

        // For each property, check if all same or all different
        return
            (allSameOrAllDifferent(colors)  // We expect all to be true.  If one is false, short circuits and we're done; false.
            && allSameOrAllDifferent(symbols)
            && allSameOrAllDifferent(numbers)
            && allSameOrAllDifferent(shadings))
    }

    // Checks if the attributes are all the same, all different, or 2/3 match.
    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let allSame = (values[0] == values[1]) && (values[1] == values[2])  // compares my enum values
        let allDifferent = Set(values).count == 3  // Set eliminates duplicate items
        return (allSame || allDifferent)  // returns TRUE IF any condition IS true or returns FALSE IF both are false
    }
}
