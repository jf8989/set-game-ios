/// Path: SetGameTests/Model/SetGameRulesTests.swift
/// Role: Unit tests for SetGame rules: initial deal, normal draw, replace/remove logic, score updates

import XCTest

@testable import set_game

final class SetGameRulesTests: XCTestCase {

    func testInitialDeal_DealsTwelveCardsAndReducesDeck() {
        // Given: a freshly initialized game
        let gameRules = SetGameRules()

        // When: the game initializes (init triggers generateDeck → dealInitialCards)
        // (no explicit action required)

        // Then: there are exactly twelve cards on the table and the deck shrank accordingly
        XCTAssertEqual(gameRules.tableCards.count, 12, "Initial table should have exactly twelve cards.")
        XCTAssertEqual(gameRules.deck.count, 81 - 12, "Deck should have sixty-nine cards remaining after the initial deal.")
        XCTAssertEqual(gameRules.selectedCards.count, 0, "No cards should be selected after initialization.")
        XCTAssertEqual(gameRules.setEvalStatus, .none, "Evaluation status should start at .none.")
        XCTAssertEqual(gameRules.score, 0, "Score should start at zero.")
    }

    func testDealThreeMore_WhenNoPendingMatch_AppendsUpToThreeFromDeck() {
        // Given: a game with a known deck size and no pending match
        var gameRules = SetGameRules()
        gameRules.setEvalStatus = .none
        let originalTableCount = gameRules.tableCards.count
        let originalDeckCount = gameRules.deck.count

        // When: the player requests to deal more cards
        gameRules.dealCards()

        // Then: up to three cards move from deck to table (bounded by remaining deck)
        XCTAssertEqual(
            gameRules.tableCards.count,
            originalTableCount + min(3, originalDeckCount),
            "Table should grow by at most three cards."
        )
        XCTAssertEqual(gameRules.deck.count, max(0, originalDeckCount - 3), "Deck should decrease by up to three cards.")
    }

    func testDealThreeMore_WhenMatchFound_DeckNonEmpty_ReplacesMatchedCardsInPlace() {
        // Given: a game where three selected cards form a valid set and the deck has spare cards
        var gameRules = SetGameRules()
        let validSet = TestCardFactory.makeValidSetTriplet()
        gameRules.tableCards.replaceSubrange(0..<3, with: validSet)
        gameRules.selectedCards = validSet
        gameRules.setEvalStatus = .found
        let originalDeckCount = gameRules.deck.count

        // When: the user deals cards (after a found set)
        gameRules.dealCards()

        // Then: the three selected cards are replaced from deck (not appended) and selection resets
        XCTAssertEqual(gameRules.tableCards.count, 12, "Table should remain at twelve after in-place replacement.")
        XCTAssertEqual(gameRules.deck.count, originalDeckCount - 3, "Deck should provide exactly three replacement cards.")
        XCTAssertTrue(gameRules.selectedCards.isEmpty, "Selection should be cleared after replacement.")
        XCTAssertEqual(gameRules.setEvalStatus, .none, "Status should reset to .none after processing a found set.")
    }

    func testDealThreeMore_WhenMatchFound_DeckEmpty_RemovesMatchedCardsFromTable() {
        // Given: a game with an empty deck and a found set on the table
        var gameRules = SetGameRules()
        gameRules.deck.removeAll()
        let matchedTriplet = TestCardFactory.makeValidSetTriplet()
        gameRules.tableCards = matchedTriplet
        gameRules.selectedCards = matchedTriplet
        gameRules.setEvalStatus = .found

        // When: the user deals cards
        gameRules.dealCards()

        // Then: the matched cards are removed (no replacements available)
        XCTAssertTrue(gameRules.tableCards.isEmpty, "Table should be empty after removing matched cards with no deck left.")
        XCTAssertTrue(gameRules.selectedCards.isEmpty, "Selection should be cleared.")
        XCTAssertEqual(gameRules.setEvalStatus, .none, "Status resets to .none after processing.")
    }

    func testChoose_WhenThirdSelectionCompletesValidSet_SetsFoundAndRewardsScore() {
        // Given: three cards on table that make a valid set and an empty selection
        var gameRules = SetGameRules()
        let validSet = TestCardFactory.makeValidSetTriplet()
        gameRules.tableCards.replaceSubrange(0..<3, with: validSet)
        gameRules.selectedCards.removeAll()
        gameRules.setEvalStatus = .none
        let originalScore = gameRules.score

        // When: the user selects three cards that form a set
        gameRules.choose(this: validSet[0])
        gameRules.choose(this: validSet[1])
        gameRules.choose(this: validSet[2])

        // Then: status becomes found and score increases by the reward
        XCTAssertEqual(gameRules.setEvalStatus, .found, "Selecting a valid set should mark status as found.")
        XCTAssertEqual(
            gameRules.score,
            originalScore + SetGameRules.Rules.matchScoreReward,
            "Score should increase by match reward."
        )
    }

    func testChoose_WhenThirdSelectionIsMismatch_SetsFailAndPenalizesScore() {
        // Given: three cards that do not form a set
        var gameRules = SetGameRules()
        let invalidSet = TestCardFactory.makeInvalidSetTriplet()
        gameRules.tableCards.replaceSubrange(0..<3, with: invalidSet)
        let originalScore = gameRules.score

        // When: the user selects those three cards
        gameRules.choose(this: invalidSet[0])
        gameRules.choose(this: invalidSet[1])
        gameRules.choose(this: invalidSet[2])

        // Then: status is fail and score decreases by mismatch penalty
        XCTAssertEqual(gameRules.setEvalStatus, .fail, "Mismatch should mark status as fail.")
        XCTAssertEqual(
            gameRules.score,
            originalScore - SetGameRules.Rules.mismatchScorePenalty,
            "Score should decrease by mismatch penalty."
        )
    }
}
