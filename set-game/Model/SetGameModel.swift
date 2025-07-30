// Model/SetGameModel.swift

import Foundation

struct SetGameModel {
    private(set) var deck: [SetCard] = []

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
        
        let card1 = deck[0]
        let card2 = deck[1]
        let card3 = deck[2]
        let result = isSet(card1: card1, card2: card2, card3: card3)
        print("Testing cards")
        print(card1)
        print(card2)
        print(card3)
        print("Is this a set?\(result ? "Yes" : "No")")
    }

    // Checks if the attributes are all the same, all different, or 2/3 match.
    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let allSame = values[0] == values[1] && values[1] == values[2]
        let allDifferent = Set(values).count == 3  // Set eliminates duplicate items
        return allSame || allDifferent  // returns whichever condition is true
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
}
