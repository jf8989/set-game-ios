/// Path: SetGameTests/Components/ActionButtonsTests.swift
/// Role: Unit-test ActionButtonsView helpers + toggle paths via real view init

import SwiftUI
import XCTest

@testable import set_game

// MARK: - ActionButtons tests
final class ActionButtonsTests: XCTestCase {

    // MARK: Logic helpers
    func testDeckOverlayOpacity_BehavesAsExpected() {
        // Given/When: requesting overlay opacity for empty vs non-empty deck.
        // Then: empty deck → 0.0 (no overlay), non-empty deck → 0.5 (dim overlay).
        XCTAssertEqual(
            ActionButtonsView.deckOverlayOpacity(isDeckEmpty: true),
            0.0,
            "Empty deck should produce zero overlay opacity."
        )
        XCTAssertEqual(
            ActionButtonsView.deckOverlayOpacity(isDeckEmpty: false),
            0.5,
            "Non-empty deck should produce a dim overlay opacity."
        )
    }

    func testDiscardStrokeOpacity_BehavesAsExpected() {
        // Given/When: requesting discard stroke opacity for empty vs non-empty discard pile.
        // Then: empty discard → 0.0, non-empty discard → 1.0.
        XCTAssertEqual(
            ActionButtonsView.discardStrokeOpacity(isDiscardEmpty: true),
            0.0,
            "Empty discard pile should have zero stroke opacity."
        )
        XCTAssertEqual(
            ActionButtonsView.discardStrokeOpacity(isDiscardEmpty: false),
            1.0,
            "Non-empty discard pile should have full stroke opacity."
        )
    }

    // MARK: Toggle paths (body execution)
    func testActionButtonsView_GameStarted_WithDeckAndDiscard_ComputesBody() {
        // Given: game started with at least one card in both deck and discard.
        let deckCardsForTest = [
            CardSet(id: UUID(), color: .purple, symbol: .squiggle, shading: .striped, number: .one)
        ]
        let discardCardsForTest = [
            CardSet(id: UUID(), color: .red, symbol: .diamond, shading: .solid, number: .three)
        ]
        let actionButtonsView = ActionButtonsView(
            hasGameStarted: true,
            startNewGame: {},
            dealThreeMore: {},
            isDeckEmpty: false,
            onStartGame: {},
            shuffle: {},
            deck: deckCardsForTest,
            discardPile: discardCardsForTest,
            namespace: TestNamespaceShim.id
        )

        // When: computing the view body (touches conditional branches and overlays).
        _ = actionButtonsView.body

        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    func testActionButtonsView_GameStarted_EmptyDeckAndDiscard_ComputesBody() {
        // Given: game started but both deck and discard are empty.
        let actionButtonsView = ActionButtonsView(
            hasGameStarted: true,
            startNewGame: {},
            dealThreeMore: {},
            isDeckEmpty: true,
            onStartGame: {},
            shuffle: {},
            deck: [],
            discardPile: [],
            namespace: TestNamespaceShim.id
        )

        // When: computing the view body.
        _ = actionButtonsView.body

        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    func testActionButtonsView_NotStarted_ShowsGetStartedButtonPath() {
        // Given: game not started; the "Get Started" path should render.
        let actionButtonsView = ActionButtonsView(
            hasGameStarted: false,
            startNewGame: {},
            dealThreeMore: {},
            isDeckEmpty: true,
            onStartGame: {},
            shuffle: {},
            deck: [],
            discardPile: [],
            namespace: TestNamespaceShim.id
        )

        // When: computing the view body.
        _ = actionButtonsView.body

        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }
}
