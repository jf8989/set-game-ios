/// Path: SetGameTests/Model/SetGameRulesTests.swift
/// Role: Unit tests for SetGame rules: initial deal, normal draw, replace/remove logic, score updates

import XCTest

@testable import set_game

final class SetGameRulesTests: XCTestCase {

    func testInitialDeal_DealsTwelveCardsAndReducesDeck() {
        // Given: a freshly initialized game
        var game = SetGame()

        // When: the game initializes (init triggers generateDeck → dealInitialCards)
        // (no explicit action required)

        // Then: there are exactly twelve cards on the table and the deck shrank accordingly
        XCTAssertEqual(game.tableCards.count, 12, "Initial table should have exactly twelve cards.")
        XCTAssertEqual(game.deck.count, 81 - 12, "Deck should have sixty-nine cards remaining after the initial deal.")
        XCTAssertEqual(game.selectedCards.count, 0, "No cards should be selected after initialization.")
        XCTAssertEqual(game.setEvalStatus, .none, "Evaluation status should start at .none.")
        XCTAssertEqual(game.score, 0, "Score should start at zero.")
    }

    func testDealThreeMore_WhenNoPendingMatch_AppendsUpToThreeFromDeck() {
        // Given: a game with a known deck size and no pending match
        var game = SetGame()
        game.setEvalStatus = .none
        let originalTableCount = game.tableCards.count
        let originalDeckCount = game.deck.count

        // When: the player requests to deal more cards
        game.dealCards()

        // Then: up to three cards move from deck to table (bounded by remaining deck)
        XCTAssertEqual(
            game.tableCards.count,
            originalTableCount + min(3, originalDeckCount),
            "Table should grow by at most three cards."
        )
        XCTAssertEqual(game.deck.count, max(0, originalDeckCount - 3), "Deck should decrease by up to three cards.")
    }

    func testDealThreeMore_WhenMatchFound_DeckNonEmpty_ReplacesMatchedCardsInPlace() {
        // Given: a game where three selected cards form a valid set and the deck has spare cards
        var game = SetGame()
        let validSet = TestCardFactory.makeValidSetTriplet()
        game.tableCards.replaceSubrange(0..<3, with: validSet)
        game.selectedCards = validSet
        game.setEvalStatus = .found
        let originalDeckCount = game.deck.count

        // When: the user deals cards (after a found set)
        game.dealCards()

        // Then: the three selected cards are replaced from deck (not appended) and selection resets
        XCTAssertEqual(game.tableCards.count, 12, "Table should remain at twelve after in-place replacement.")
        XCTAssertEqual(game.deck.count, originalDeckCount - 3, "Deck should provide exactly three replacement cards.")
        XCTAssertTrue(game.selectedCards.isEmpty, "Selection should be cleared after replacement.")
        XCTAssertEqual(game.setEvalStatus, .none, "Status should reset to .none after processing a found set.")
    }

    func testDealThreeMore_WhenMatchFound_DeckEmpty_RemovesMatchedCardsFromTable() {
        // Given: a game with an empty deck and a found set on the table
        var game = SetGame()
        game.deck.removeAll()
        let matchedTriplet = TestCardFactory.makeValidSetTriplet()
        game.tableCards = matchedTriplet
        game.selectedCards = matchedTriplet
        game.setEvalStatus = .found

        // When: the user deals cards
        game.dealCards()

        // Then: the matched cards are removed (no replacements available)
        XCTAssertTrue(game.tableCards.isEmpty, "Table should be empty after removing matched cards with no deck left.")
        XCTAssertTrue(game.selectedCards.isEmpty, "Selection should be cleared.")
        XCTAssertEqual(game.setEvalStatus, .none, "Status resets to .none after processing.")
    }

    func testChoose_WhenThirdSelectionCompletesValidSet_SetsFoundAndRewardsScore() {
        // Given: three cards on table that make a valid set and an empty selection
        var game = SetGame()
        let validSet = TestCardFactory.makeValidSetTriplet()
        game.tableCards.replaceSubrange(0..<3, with: validSet)
        game.selectedCards.removeAll()
        game.setEvalStatus = .none
        let originalScore = game.score

        // When: the user selects three cards that form a set
        game.choose(this: validSet[0])
        game.choose(this: validSet[1])
        game.choose(this: validSet[2])

        // Then: status becomes found and score increases by the reward
        XCTAssertEqual(game.setEvalStatus, .found, "Selecting a valid set should mark status as found.")
        XCTAssertEqual(
            game.score,
            originalScore + SetGame.Rules.matchScoreReward,
            "Score should increase by match reward."
        )
    }

    func testChoose_WhenThirdSelectionIsMismatch_SetsFailAndPenalizesScore() {
        // Given: three cards that do not form a set
        var game = SetGame()
        let invalidSet = TestCardFactory.makeInvalidSetTriplet()
        game.tableCards.replaceSubrange(0..<3, with: invalidSet)
        let originalScore = game.score

        // When: the user selects those three cards
        game.choose(this: invalidSet[0])
        game.choose(this: invalidSet[1])
        game.choose(this: invalidSet[2])

        // Then: status is fail and score decreases by mismatch penalty
        XCTAssertEqual(game.setEvalStatus, .fail, "Mismatch should mark status as fail.")
        XCTAssertEqual(
            game.score,
            originalScore - SetGame.Rules.mismatchScorePenalty,
            "Score should decrease by mismatch penalty."
        )
    }
}
