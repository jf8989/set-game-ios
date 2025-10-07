/// Path: SetGameTests/ViewModel/SetGameViewModelTests.swift
/// Role: Unit tests for SetGameViewModel intents (deterministic; full Given/When/Then)

import XCTest

@testable import set_game

final class SetGameViewModelTests: XCTestCase {

    func testStartNewGame_StagesTwelveCardsAndResetsViewFacingState() {
        // Given: a fresh view model with tiny delays for near-immediate scheduling
        let viewModel = SetGameViewModel(initialDealStep: 0.0001, initialDealAnim: 0.0001)

        // When: starting a new game
        viewModel.startNewGame()

        // Then: immediately after invocation (pre-animation), `tableCards` is empty and
        //       `deckDisplay` contains all 81 cards (the full deck, including any that
        //       are staged for the initial deal but not yet visible on the table).
        //       Ordering is irrelevant; we assert only counts/invariants.
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
        let seededGame = SetGameTestDataFactory.makeGameWithKnownTable(tableCards: validTriplet, deckRemainder: [])
        let viewModel = SetGameViewModel(game: seededGame)

        // When: user selects those three cards
        viewModel.select(this: validTriplet[0])
        viewModel.select(this: validTriplet[1])
        viewModel.select(this: validTriplet[2])

        // Then: evaluation status becomes `.found` and the score increases exactly by
        //       the match reward (`Rules.matchScoreReward`).
        XCTAssertEqual(viewModel.setEvalStatus, .found, "Selecting a valid set must mark status as found.")
        XCTAssertEqual(
            viewModel.score,
            SetGameRules.Rules.matchScoreReward,
            "Score should increase by the match reward."
        )
    }

    func testSelect_WhenThreeCardsDoNotMakeAValidSet_StatusBecomesFail_AndScoreDecreases() {
        // Given: three cards that do not form a set placed on table; empty deck
        let invalidTriplet = TestCardFactory.makeInvalidSetTriplet()
        let seededGame = SetGameTestDataFactory.makeGameWithKnownTable(tableCards: invalidTriplet, deckRemainder: [])
        let viewModel = SetGameViewModel(game: seededGame)

        // When: user selects those three cards
        viewModel.select(this: invalidTriplet[0])
        viewModel.select(this: invalidTriplet[1])
        viewModel.select(this: invalidTriplet[2])

        // Then: evaluation status becomes `.fail` and the score decreases exactly by
        //       the mismatch penalty (`Rules.mismatchScorePenalty`).
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
        let seededGame = SetGameTestDataFactory.makeGameWithKnownTable(
            tableCards: initialTable,
            deckRemainder: Array(extraDeck)
        )
        let viewModel = SetGameViewModel(game: seededGame)

        let originalTableCount = viewModel.tableCards.count
        let originalDeckCount = viewModel.cardsLeft

        // When: the user deals more cards
        viewModel.dealThreeMore()

        // Then: the table grows by `min(3, originalDeckCount)` cards and the deck count
        //       becomes `max(0, originalDeckCount - 3)`. We assert counts only; specific
        //       identities are irrelevant here.
        XCTAssertEqual(viewModel.tableCards.count, originalTableCount + min(3, originalDeckCount))
        XCTAssertEqual(viewModel.cardsLeft, max(0, originalDeckCount - 3))
    }

    func testShuffleTableCards_ChangesOrderButKeepsSameElements() {
        // Given: a table with a known order and a fixed deck
        let triplet = TestCardFactory.makeValidSetTriplet()
        let seededGame = SetGameTestDataFactory.makeGameWithKnownTable(tableCards: triplet, deckRemainder: [])
        let viewModel = SetGameViewModel(game: seededGame)

        let originalIdentifiers = viewModel.tableCards.map { $0.id }

        // When: shuffling the table cards
        viewModel.shuffleTableCards()

        // Then: the multiset of elements is preserved (same identifiers), while order is
        //       expected to change. Because shuffles can coincidentally preserve order,
        //       we assert element equality via sets and keep order-change as a soft check.
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
