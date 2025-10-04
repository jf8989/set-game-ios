/// Path: SetGameTests/Model/SetEvaluationHelpersTests.swift
/// Role: Unit tests for Array<CardSet>.isSet and Array<Hashable>.allSameOrAllDifferent

import XCTest

@testable import set_game

final class SetEvaluationHelpersTests: XCTestCase {

    func testIsSet_ReturnsTrue_ForAllSameEachAttribute() {
        // Given: three cards identical in every attribute (identifier may differ).
        let cardOne = TestCardFactory.makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one)
        let cardTwo = TestCardFactory.makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one)
        let cardThree = TestCardFactory.makeCard(color: .red, symbol: .diamond, shading: .solid, number: .one)

        // When: evaluating the three-card selection for set validity.
        let selectedCardsTriplet = [cardOne, cardTwo, cardThree]

        // Then: a triplet with all-same attributes is a valid set.
        XCTAssertTrue(selectedCardsTriplet.isSet, "All-same across attributes should be a valid set.")
    }

    func testIsSet_ReturnsTrue_ForAllDifferentEachAttribute() {
        // Given: three cards where each attribute is all-different across the triplet.
        let selectedCardsTriplet = TestCardFactory.makeValidSetTriplet()

        // When: evaluating the selection.
        let evaluationResult = selectedCardsTriplet.isSet

        // Then: a triplet with all-different attributes is a valid set.
        XCTAssertTrue(evaluationResult, "All-different across attributes should be a valid set.")
    }

    func testIsSet_ReturnsFalse_ForMixedAttributes() {
        // Given: three cards where at least one attribute is mixed
        //        (neither all-same nor all-different).
        let selectedCardsTriplet = TestCardFactory.makeInvalidSetTriplet()

        // When: evaluating the selection.
        let evaluationResult = selectedCardsTriplet.isSet

        // Then: mixed attributes invalidate the set.
        XCTAssertFalse(evaluationResult, "Mixed attribute should invalidate the set.")
    }

    func testIsSet_ReturnsFalse_WhenSelectionCountIsNotThree() {
        // Given: selections with sizes other than three.
        let emptySelection: [CardSet] = []
        let singleCardSelection: [CardSet] = [TestCardFactory.makeValidSetTriplet()[0]]
        let doubleCardSelection: [CardSet] = Array(TestCardFactory.makeValidSetTriplet().prefix(2))
        var fourCardSelection = TestCardFactory.makeValidSetTriplet()
        fourCardSelection.append(TestCardFactory.makeValidSetTriplet()[0])

        // When: evaluating each selection.
        let evaluationResults = [
            emptySelection.isSet,
            singleCardSelection.isSet,
            doubleCardSelection.isSet,
            fourCardSelection.isSet,
        ]

        // Then: only exactly three cards can be evaluated as a set; all others are false.
        XCTAssertEqual(
            evaluationResults,
            [false, false, false, false],
            "Only exactly three cards can be evaluated as a set."
        )
    }

    func testAllSameOrAllDifferent_BehavesForHashableScenarios() {
        // Given: several arrays of Hashable values representing attribute projections.
        let allSameValues = [1, 1, 1]
        let allDifferentValues = [1, 2, 3]
        let mixedValues = [1, 1, 2]

        // When: checking the helper.
        let resultAllSame = allSameValues.allSameOrAllDifferent
        let resultAllDifferent = allDifferentValues.allSameOrAllDifferent
        let resultMixed = mixedValues.allSameOrAllDifferent

        // Then: only all-same and all-different pass; mixed fails.
        XCTAssertTrue(resultAllSame, "All identical values should be accepted.")
        XCTAssertTrue(resultAllDifferent, "All distinct values should be accepted.")
        XCTAssertFalse(resultMixed, "Mixed arrays should be rejected.")
    }
}
