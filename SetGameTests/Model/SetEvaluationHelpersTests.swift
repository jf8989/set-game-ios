/// Path: SetGameTests/Model/SetEvaluationHelpersTests.swift
/// Role: Unit tests for Array<CardSet>.isSet and Array<Hashable>.allSameOrAllDifferent

import XCTest

@testable import set_game

final class SetEvaluationHelpersTests: XCTestCase {

    func testIsSet_ReturnsTrue_ForAllSameEachAttribute() {
        // Given: three cards identical in every attribute except identifier
        let cardOne = TestCardFactory.makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one)
        let cardTwo = TestCardFactory.makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one)
        let cardThree = TestCardFactory.makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one)

        // When: evaluating the selection
        let selectedCards = [cardOne, cardTwo, cardThree]

        // Then: this is a valid set (all attributes the same)
        XCTAssertTrue(selectedCards.isSet, "All-same across attributes should be a valid set.")
    }

    func testIsSet_ReturnsTrue_ForAllDifferentEachAttribute() {
        // Given: three cards where each attribute is all-different
        let selectedCards = TestCardFactory.makeValidSetTriplet()

        // When: evaluating the selection
        let evaluationResult = selectedCards.isSet

        // Then: this is a valid set (all-different across attributes)
        XCTAssertTrue(evaluationResult, "All-different across attributes should be a valid set.")
    }

    func testIsSet_ReturnsFalse_ForMixedAttributes() {
        // Given: three cards where at least one attribute is mixed (neither all-same nor all-different)
        let selectedCards = TestCardFactory.makeInvalidSetTriplet()

        // When: evaluating the selection
        let evaluationResult = selectedCards.isSet

        // Then: not a valid set
        XCTAssertFalse(evaluationResult, "Mixed attribute should invalidate the set.")
    }

    func testIsSet_ReturnsFalse_WhenSelectionCountIsNotThree() {
        // Given: selections of size zero, one, two, and four
        let emptySelection: [CardSet] = []
        let singleSelection: [CardSet] = [TestCardFactory.makeValidSetTriplet()[0]]
        let doubleSelection: [CardSet] = Array(TestCardFactory.makeValidSetTriplet().prefix(2))
        var fourSelection = TestCardFactory.makeValidSetTriplet()
        fourSelection.append(TestCardFactory.makeValidSetTriplet()[0])

        // When: evaluating each selection
        let evaluationResults = [
            emptySelection.isSet,
            singleSelection.isSet,
            doubleSelection.isSet,
            fourSelection.isSet,
        ]

        // Then: only triplets are candidates; others must be false
        XCTAssertEqual(
            evaluationResults,
            [false, false, false, false],
            "Only exactly three cards can be evaluated as a set."
        )
    }

    func testAllSameOrAllDifferent_BehavesForHashableScenarios() {
        // Given: several arrays of hashable values
        let allSameValues = [1, 1, 1]
        let allDifferentValues = [1, 2, 3]
        let mixedValues = [1, 1, 2]

        // When: checking the helper
        let resultAllSame = allSameValues.allSameOrAllDifferent
        let resultAllDifferent = allDifferentValues.allSameOrAllDifferent
        let resultMixed = mixedValues.allSameOrAllDifferent

        // Then: only all-same and all-different should succeed
        XCTAssertTrue(resultAllSame, "All identical values should be accepted.")
        XCTAssertTrue(resultAllDifferent, "All distinct values should be accepted.")
        XCTAssertFalse(resultMixed, "Mixed arrays should be rejected.")
    }
}
