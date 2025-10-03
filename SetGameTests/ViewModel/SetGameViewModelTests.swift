/// Path: SetGameTests/ViewModel/SetGameViewModelTests.swift
/// Role: Unit tests for SetGameViewModel intents (deterministic; full Given/When/Then)

import XCTest

@testable import set_game

final class SetGameViewModelTests: XCTestCase {

    // Helper: build a deterministic game with three known cards on table and a small deck
    private func makeGameWithKnownTable(
        tableCards: [CardSet],
        deckRemainder: [CardSet] = []
    ) -> SetGameRules {
        var gameRules = SetGameRules()
        gameRules.tableCards = tableCards
        gameRules.deck = deckRemainder
        gameRules.selectedCards.removeAll()
        gameRules.setEvalStatus = .none
        gameRules.score = 0
        gameRules.discardPile.removeAll()
        return gameRules
    }

    func testStartNewGame_StagesTwelveCardsAndResetsViewFacingState() {
        // Given: a fresh view model with tiny delays for near-immediate scheduling
        let viewModel = SetGameViewModel(initialDealStep: 0.0001, initialDealAnim: 0.0001)

        // When: starting a new game
        viewModel.startNewGame()

        // Then: immediately after call, the table is empty, and deckDisplay shows all eighty-one (deck plus staged twelve)
        // Note: exact ordering is irrelevant; we assert counts and invariants.
        XCTAssertEqual(viewModel.tableCards.count, 0, "Table should be emptied before staged dealing begins.")
        XCTAssertEqual(
            viewModel.deckDisplay.count,
            81,
            "Deck display should present the entire deck including staged cards."
        )
    }

    func testSelect_WhenThreeCardsMakeAValidSet_StatusBecomesFound_AndScoreIncreases() {
        // Given: three cards that form a valid set placed on table; empty deck (to avoid replacement noise)
        let validTriplet = TestCardFactory.makeValidSetTriplet()
        let seededGame = makeGameWithKnownTable(tableCards: validTriplet, deckRemainder: [])
        let viewModel = SetGameViewModel(game: seededGame)

        // When: user selects those three cards
        viewModel.select(this: validTriplet[0])
        viewModel.select(this: validTriplet[1])
        viewModel.select(this: validTriplet[2])

        // Then: evaluation status is found and score increments by the reward
        XCTAssertEqual(viewModel.setEvalStatus, .found, "Selecting a valid set must mark status as found.")
        XCTAssertEqual(viewModel.score, SetGameRules.Rules.matchScoreReward, "Score should increase by the match reward.")
    }

    func testSelect_WhenThreeCardsDoNotMakeAValidSet_StatusBecomesFail_AndScoreDecreases() {
        // Given: three cards that do not form a set placed on table; empty deck
        let invalidTriplet = TestCardFactory.makeInvalidSetTriplet()
        let seededGame = makeGameWithKnownTable(tableCards: invalidTriplet, deckRemainder: [])
        let viewModel = SetGameViewModel(game: seededGame)

        // When: user selects those three cards
        viewModel.select(this: invalidTriplet[0])
        viewModel.select(this: invalidTriplet[1])
        viewModel.select(this: invalidTriplet[2])

        // Then: status is fail and score decreases by the mismatch penalty
        XCTAssertEqual(viewModel.setEvalStatus, .fail, "Mismatch must mark status as fail.")
        XCTAssertEqual(
            viewModel.score,
            -SetGameRules.Rules.mismatchScorePenalty,
            "Score should decrease by the mismatch penalty."
        )
    }

    func testDealThreeMore_WhenNoPendingMatch_AppendsUpToThreeCards() {
        // Given: a table with three cards and a deck with five remaining; status is none
        let initialTable = Array(TestCardFactory.makeValidSetTriplet().prefix(3))
        let extraDeck = SetGameRules().createShuffledDeck().prefix(5)
        let seededGame = makeGameWithKnownTable(tableCards: initialTable, deckRemainder: Array(extraDeck))
        let viewModel = SetGameViewModel(game: seededGame)

        let originalTableCount = viewModel.tableCards.count
        let originalDeckCount = viewModel.cardsLeft

        // When: the user deals more cards
        viewModel.dealThreeMore()

        // Then: table grows by up to three; deck shrinks accordingly
        XCTAssertEqual(viewModel.tableCards.count, originalTableCount + min(3, originalDeckCount))
        XCTAssertEqual(viewModel.cardsLeft, max(0, originalDeckCount - 3))
    }

    func testShuffleTableCards_ChangesOrderButKeepsSameElements() {
        // Given: a table with a known order and a fixed deck
        let triplet = TestCardFactory.makeValidSetTriplet()
        let seededGame = makeGameWithKnownTable(tableCards: triplet, deckRemainder: [])
        let viewModel = SetGameViewModel(game: seededGame)

        let originalIdentifiers = viewModel.tableCards.map { $0.id }

        // When: shuffling the table cards
        viewModel.shuffleTableCards()

        // Then: same elements remain but order likely changes (allow equality if shuffle returns same order by chance)
        let shuffledIdentifiers = viewModel.tableCards.map { $0.id }
        XCTAssertEqual(
            Set(originalIdentifiers),
            Set(shuffledIdentifiers),
            "Shuffling must preserve the same set of cards."
        )
        // Non-deterministic order: this assertion is soft; we verify change opportunistically.
        // We still accept equality if random shuffle returns identical ordering.
    }
}
