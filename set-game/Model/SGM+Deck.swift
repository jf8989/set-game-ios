// Model/SGM+Deck.swift

import Foundation

/// Creates and shuffles the full deck, then deals 12 cards
extension SetGameModel {
    mutating func createDeckShuffleAndDeal() {
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

    mutating func dealInitialCards() {
        tableCards.append(contentsOf: deck.prefix(12))
        deck.removeFirst(12)
    }
}
