/// Path: SetGameTests/Model/DeckFactoryTests.swift
/// Role: Validates deck size, uniqueness, and attribute distribution (no abbreviations; full GWT)

import XCTest

@testable import set_game

/// Hashable key that ignores the identifier and encodes only the card attributes.
/// This replaces the previous tuple-based approach, which cannot conform to `Hashable` in this toolchain.
private struct CardAttributesKey: Hashable {
    let color: CardColor
    let symbol: CardSymbol
    let shading: CardShading
    let number: CardNumber
}

final class DeckFactoryTests: XCTestCase {

    func testCreateShuffledDeck_ProducesEightyOneUniqueCards() {
        // Given: the deck factory (rules object capable of producing a full deck).
        // When:  creating a new shuffled deck via `createShuffledDeck()`.
        let createdDeck = SetGameRules().createShuffledDeck()

        // Then:  deck count is exactly 81 and every (color, symbol, shading, number)
        //        combination appears once. We ignore the `id` by hashing only attributes
        //        through `CardAttributesKey` to validate true attribute-level uniqueness.
        XCTAssertEqual(createdDeck.count, 81, "Deck should contain exactly eighty-one cards.")

        // We map each card to an attribute-only key so identifiers do not affect uniqueness.
        let uniqueAttributeKeys = Set(
            createdDeck.map {
                CardAttributesKey(
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
        // Given: a freshly created deck of 81 cards.
        let createdDeck = SetGameRules().createShuffledDeck()

        // When:  counting occurrences for each attribute case across the full deck.
        // We compute per-attribute histograms to verify uniform distribution across cases.
        let colorCounts = Dictionary(grouping: createdDeck, by: { $0.color }).mapValues { $0.count }
        let symbolCounts = Dictionary(grouping: createdDeck, by: { $0.symbol }).mapValues { $0.count }
        let shadingCounts = Dictionary(grouping: createdDeck, by: { $0.shading }).mapValues { $0.count }
        let numberCounts = Dictionary(grouping: createdDeck, by: { $0.number }).mapValues { $0.count }

        // Then:  each case appears 27 times, because for any fixed case there are 3×3×3 = 27
        //        combinations of the remaining three attributes (balanced distribution).
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
