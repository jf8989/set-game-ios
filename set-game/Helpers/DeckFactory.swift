//  Helpers/DeckFactory.swift

import Foundation

struct DeckFactory {
    static func createDeckShuffleAndDeal() -> [CardSet] {
        CardColor.allCases.flatMap { color in
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
    }
}
