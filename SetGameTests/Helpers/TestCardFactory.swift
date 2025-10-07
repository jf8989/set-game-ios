/// Path: SetGameTests/Helpers/TestCardFactory.swift
/// Role: Deterministic builders for CardSet values used across tests (no abbreviations)

import Foundation

@testable import set_game

enum TestCardFactory {
    /// Builds a single CardSet with explicit attributes.
    static func makeCard(
        identifier: UUID = UUID(),
        color: CardColor,
        symbol: CardSymbol,
        shading: CardShading,
        number: CardNumber
    ) -> CardSet {
        return CardSet(
            id: identifier,
            color: color,
            symbol: symbol,
            shading: shading,
            number: number
        )
    }

    /// Builds three cards that form a valid Set:
    /// all attributes are all-different across the triplet.
    static func makeValidSetTriplet() -> [CardSet] {
        return [
            makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one),
            makeCard(color: .green, symbol: .oval, shading: .open, number: .two),
            makeCard(color: .purple, symbol: .squiggle, shading: .striped, number: .three),
        ]
    }

    /// Builds three cards that do NOT form a Set:
    /// at least one attribute is mixed (neither all-same nor all-different).
    static func makeInvalidSetTriplet() -> [CardSet] {
        return [
            makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one),
            makeCard(color: .red, symbol: .diamond, shading: .open, number: .two),
            makeCard(color: .green, symbol: .oval, shading: .open, number: .three),
        ]
    }
}
