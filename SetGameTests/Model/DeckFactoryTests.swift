/// Path: SetGameTests/Model/DeckFactoryTests.swift
/// Role: Validates deck size, uniqueness, and attribute distribution (no abbreviations; full GWT)

import XCTest

@testable import set_game

/// Hashable key that ignores the identifier and encodes only the card attributes.
/// This replaces the previous tuple-based approach, which cannot conform to `Hashable` in this toolchain.
private struct AttributeKey: Hashable {
    let color: CardColor
    let symbol: CardSymbol
    let shading: CardShading
    let number: CardNumber
}

final class DeckFactoryTests: XCTestCase {

    func testCreateShuffledDeck_ProducesEightyOneUniqueCards() {
        // Given: the deck factory
        // When: creating a new shuffled deck
        let createdDeck = DeckFactory.createShuffledDeck()

        // Then: there are eighty-one cards and all (color, symbol, shading, number) combinations are unique
        XCTAssertEqual(createdDeck.count, 81, "Set should contain exactly eighty-one cards.")

        let uniqueAttributeKeys = Set(
            createdDeck.map {
                AttributeKey(
                    color: $0.color,
                    symbol: $0.symbol,
                    shading: $0.shading,
                    number: $0.number
                )
            }
        )
        XCTAssertEqual(uniqueAttributeKeys.count, 81, "All attribute combinations must be unique.")
    }

    func testCreateShuffledDeck_DistributionPerAttributeCase_IsBalanced() {
        // Given: a freshly created deck
        let createdDeck = DeckFactory.createShuffledDeck()

        // When: counting occurrences for each attribute case
        let colorCounts = Dictionary(grouping: createdDeck, by: { $0.color }).mapValues { $0.count }
        let symbolCounts = Dictionary(grouping: createdDeck, by: { $0.symbol }).mapValues { $0.count }
        let shadingCounts = Dictionary(grouping: createdDeck, by: { $0.shading }).mapValues { $0.count }
        let numberCounts = Dictionary(grouping: createdDeck, by: { $0.number }).mapValues { $0.count }

        // Then: each case appears twenty-seven times
        XCTAssertEqual(colorCounts[.red], 27)
        XCTAssertEqual(colorCounts[.green], 27)
        XCTAssertEqual(colorCounts[.purple], 27)

        XCTAssertEqual(symbolCounts[.diamond], 27)
        XCTAssertEqual(symbolCounts[.oval], 27)
        XCTAssertEqual(symbolCounts[.squiggle], 27)

        XCTAssertEqual(shadingCounts[.solid], 27)
        XCTAssertEqual(shadingCounts[.open], 27)
        XCTAssertEqual(shadingCounts[.striped], 27)

        XCTAssertEqual(numberCounts[.one], 27)
        XCTAssertEqual(numberCounts[.two], 27)
        XCTAssertEqual(numberCounts[.three], 27)
    }
}
