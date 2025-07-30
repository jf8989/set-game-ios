// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    private(set) var deck: [SetCard] = []
    private(set) var selectedCardIDs = Set<UUID>()

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
    }

    // Fetch the three cards and their individual attributes for evaluation.
    func isSet(card1: SetCard, card2: SetCard, card3: SetCard) -> Bool {
        let colors = [card1.color, card2.color, card3.color]
        let symbols = [card1.symbol, card2.symbol, card3.symbol]
        let numbers = [card1.number, card2.number, card3.number]
        let shadings = [card1.shading, card2.shading, card3.shading]

        // For each property, check if all same or all different
        return allSameOrAllDifferent(colors)
            && allSameOrAllDifferent(symbols)
            && allSameOrAllDifferent(numbers)
            && allSameOrAllDifferent(shadings)
    }

    // Checks if the attributes are all the same, all different, or 2/3 match.
    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let allSame = values[0] == values[1] && values[1] == values[2]  // compares my enum values
        let allDifferent = Set(values).count == 3  // Set eliminates duplicate items
        return allSame || allDifferent  // returns whichever condition is true
    }

    // Handles card selection
    mutating func toggleSelection(for card: SetCard) {
        // First, check context before doing anything else.
        if selectedCardIDs.contains(card.id) {  // If the card's already there, deselect it.
            // deselect it
            selectedCardIDs.remove(card.id)
            print("Deselected card:", card)
        } else if selectedCardIDs.count < 3 {  // If we have less than 3 elements, it's a normal selection
            // select it
            selectedCardIDs.insert(card.id)
            print("Selected card:", card)
        } else {
            print("Already 3 selected.")
        }

        // Log current selection
        print("Selected IDs:", selectedCardIDs)

        // When 3 unique cards are selected
        if selectedCardIDs.count == 3 {
            // Find the selected cards in the deck and use them
            let selectedCards = deck.filter { selectedCardIDs.contains($0.id) }
            // as long as selectedCards has 3 elements, we're good to go
            if selectedCards.count == 3 {
                let isASet = isSet(
                    card1: selectedCards[0],
                    card2: selectedCards[1],
                    card3: selectedCards[2]
                )
                print(
                    "3 cards selected.  Is it a set? \(isASet ? "YES" : "NO")"
                )
                selectedCardIDs = []
            }
        }
    }
}
