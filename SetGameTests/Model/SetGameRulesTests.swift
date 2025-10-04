/// Path: SetGameTests/Model/SetGameRulesTests.swift
/// Role: Unit tests for SetGame rules: initial deal, normal draw, replace/remove logic, score updates

import XCTest

@testable import set_game

final class SetGameRulesTests: XCTestCase {

    func testInitialDeal_DealsTwelveCardsAndReducesDeck() {
        // Given: a freshly initialized game (constructor generates an 81-card deck and deals 12).
        let gameRules = SetGameRules()

        // When: no explicit action (the init performs the initial deal).

        // Then: exactly twelve cards are on the table, the deck has 69 cards left,
        //       selection is empty, evaluation status is `.none`, and score is zero.
        XCTAssertEqual(gameRules.tableCards.count, 12, "Initial table should have exactly twelve cards.")
        XCTAssertEqual(
            gameRules.deck.count,
            81 - 12,
            "Deck should have sixty-nine cards remaining after the initial deal."
        )
        XCTAssertEqual(gameRules.selectedCards.count, 0, "No cards should be selected after initialization.")
        XCTAssertEqual(gameRules.setEvalStatus, .none, "Evaluation status should start at .none.")
        XCTAssertEqual(gameRules.score, 0, "Score should start at zero.")
    }

    func testDealCards_WhenNoPendingMatch_AppendsUpToThreeFromDeck() {
        // Given: a game with no pending match; capture initial table/deck counts.
        var gameRules = SetGameRules()
        gameRules.setEvalStatus = .none
        let originalTableCount = gameRules.tableCards.count
        let originalDeckCount = gameRules.deck.count

        // When: requesting more cards via `dealCards()`.
        gameRules.dealCards()

        // Then: the table grows by `min(3, originalDeckCount)` and the deck becomes
        //       `max(0, originalDeckCount - 3)`. We assert counts only; identities/order are irrelevant.
        XCTAssertEqual(
            gameRules.tableCards.count,
            originalTableCount + min(3, originalDeckCount),
            "Table should grow by at most three cards."
        )
        XCTAssertEqual(
            gameRules.deck.count,
            max(0, originalDeckCount - 3),
            "Deck should decrease by up to three cards."
        )
    }

    func testDealCards_WhenMatchFound_DeckNonEmpty_ReplacesMatchedCardsInPlace() {
        // Given: three selected cards on the table form a valid set; the deck has spare cards.
        var gameRules = SetGameRules()
        let validSetTriplet = TestCardFactory.makeValidSetTriplet()
        gameRules.tableCards.replaceSubrange(0..<3, with: validSetTriplet)
        gameRules.selectedCards = validSetTriplet
        gameRules.setEvalStatus = .found
        let originalDeckCount = gameRules.deck.count

        // When: calling `dealCards()` to process the found set.
        gameRules.dealCards()

        // Then: the table size remains 12 (in-place replacement), the deck decreases by 3,
        //       selection clears, and status resets to `.none`.
        XCTAssertEqual(gameRules.tableCards.count, 12, "Table should remain at twelve after in-place replacement.")
        XCTAssertEqual(
            gameRules.deck.count,
            originalDeckCount - 3,
            "Deck should provide exactly three replacement cards."
        )
        XCTAssertTrue(gameRules.selectedCards.isEmpty, "Selection should be cleared after replacement.")
        XCTAssertEqual(gameRules.setEvalStatus, .none, "Status should reset to .none after processing a found set.")
    }

    func testDealCards_WhenMatchFound_DeckEmpty_RemovesMatchedCardsFromTable() {
        // Given: a found set on the table and an empty deck.
        var gameRules = SetGameRules()
        gameRules.deck.removeAll()
        let matchedTriplet = TestCardFactory.makeValidSetTriplet()
        gameRules.tableCards = matchedTriplet
        gameRules.selectedCards = matchedTriplet
        gameRules.setEvalStatus = .found

        // When: calling `dealCards()`.
        gameRules.dealCards()

        // Then: the matched triplet is removed (no replacements available), selection clears,
        //       and status resets to `.none`.
        XCTAssertTrue(
            gameRules.tableCards.isEmpty,
            "Table should be empty after removing matched cards with no deck left."
        )
        XCTAssertTrue(gameRules.selectedCards.isEmpty, "Selection should be cleared.")
        XCTAssertEqual(gameRules.setEvalStatus, .none, "Status resets to .none after processing.")
    }

    func testChoose_WhenThirdSelectionCompletesValidSet_SetsFoundAndRewardsScore() {
        // Given: three cards on the table that form a valid set; score baseline captured.
        var gameRules = SetGameRules()
        let validSetTriplet = TestCardFactory.makeValidSetTriplet()
        gameRules.tableCards.replaceSubrange(0..<3, with: validSetTriplet)
        gameRules.selectedCards.removeAll()
        gameRules.setEvalStatus = .none
        let originalScore = gameRules.score

        // When: selecting those three cards in sequence via `choose(this:)`.
        gameRules.choose(this: validSetTriplet[0])
        gameRules.choose(this: validSetTriplet[1])
        gameRules.choose(this: validSetTriplet[2])

        // Then: status becomes found and score increases by `Rules.matchScoreReward`.
        XCTAssertEqual(gameRules.setEvalStatus, .found, "Selecting a valid set should mark status as found.")
        XCTAssertEqual(
            gameRules.score,
            originalScore + SetGameRules.Rules.matchScoreReward,
            "Score should increase by match reward."
        )
    }

    func testChoose_WhenThirdSelectionIsMismatch_SetsFailAndPenalizesScore() {
        // Given: three cards on the table that do not form a set; score baseline captured.
        var gameRules = SetGameRules()
        let mismatchTriplet = TestCardFactory.makeInvalidSetTriplet()
        gameRules.tableCards.replaceSubrange(0..<3, with: mismatchTriplet)
        let originalScore = gameRules.score

        // When: selecting those three cards in sequence via `choose(this:)`.
        gameRules.choose(this: mismatchTriplet[0])
        gameRules.choose(this: mismatchTriplet[1])
        gameRules.choose(this: mismatchTriplet[2])

        // Then: status becomes `.fail` and score decreases by `Rules.mismatchScorePenalty`.
        XCTAssertEqual(gameRules.setEvalStatus, .fail, "Mismatch should mark status as fail.")
        XCTAssertEqual(
            gameRules.score,
            originalScore - SetGameRules.Rules.mismatchScorePenalty,
            "Score should decrease by mismatch penalty."
        )
    }
}
