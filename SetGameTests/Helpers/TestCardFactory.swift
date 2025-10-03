/// Path: SetGameTests/Helpers/TestCardFactory.swift
/// Role: Deterministic builders for CardSet values used across tests (no abbreviations)

import Foundation

@testable import set_game

enum TestCardFactory {
    /// Builds a single CardSet with explicit attributes and a stable UUID when provided.
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

    /// Builds three cards that are a **valid Set** by keeping attributes all-same or all-different.
    static func makeValidSetTriplet() -> [CardSet] {
        // Given: three cards with all-different attributes across each dimension
        // When: these are evaluated together
        // Then: they should constitute a valid Set by the game rules
        return [
            makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one),
            makeCard(color: .green, symbol: .oval, shading: .open, number: .two),
            makeCard(color: .purple, symbol: .squiggle, shading: .striped, number: .three),
        ]
    }

    /// Builds three cards that are **not** a Set (exactly one attribute violates the rule).
    static func makeInvalidSetTriplet() -> [CardSet] {
        // Given: three cards where attributes are mixed (neither all-same nor all-different)
        // When: these are evaluated together
        // Then: they must fail the Set rule
        return [
            makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one),
            makeCard(color: .red, symbol: .diamond, shading: .open, number: .two),
            makeCard(color: .green, symbol: .oval, shading: .open, number: .three),
        ]
    }
}
