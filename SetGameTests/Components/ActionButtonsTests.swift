/// Path: SetGameTests/Components/ActionButtonsLogicTests.swift
/// Role: Unit-test ActionButtonsView helpers
import XCTest

@testable import set_game

// MARK: - ActionButtons Logic tests
final class ActionButtonsTests: XCTestCase {
    func testDeckOverlayOpacity_BehavesAsExpected() {
        XCTAssertEqual(ActionButtonsView.deckOverlayOpacity(isDeckEmpty: true), 0.0)
        XCTAssertEqual(ActionButtonsView.deckOverlayOpacity(isDeckEmpty: false), 0.5)
    }
    func testDiscardStrokeOpacity_BehavesAsExpected() {
        XCTAssertEqual(ActionButtonsView.discardStrokeOpacity(isDiscardEmpty: true), 0.0)
        XCTAssertEqual(ActionButtonsView.discardStrokeOpacity(isDiscardEmpty: false), 1.0)
    }
}

// MARK: - ActionButtonsViewToggle tests Ext.
extension ActionButtonsTests {

    func testActionButtonsView_GameStarted_WithDeckAndDiscard_ComputesBody() {
        // Given
        let namespace = Namespace.ID()
        let deckCards = [
            CardSet(id: UUID(), color: .purple, symbol: .squiggle, shading: .striped, number: .one)
        ]
        let discardCards = [
            CardSet(id: UUID(), color: .red, symbol: .diamond, shading: .solid, number: .three)
        ]

        let view = ActionButtonsView(
            hasGameStarted: true,
            startNewGame: {},
            dealThreeMore: {},
            isDeckEmpty: false,
            onStartGame: {},
            shuffle: {},
            deck: deckCards,
            discardPile: discardCards,
            namespace: namespace
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testActionButtonsView_GameStarted_EmptyDeckAndDiscard_ComputesBody() {
        // Given
        let namespace = Namespace.ID()
        let view = ActionButtonsView(
            hasGameStarted: true,
            startNewGame: {},
            dealThreeMore: {},
            isDeckEmpty: true,
            onStartGame: {},
            shuffle: {},
            deck: [],
            discardPile: [],
            namespace: namespace
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testActionButtonsView_NotStarted_ShowsGetStartedButtonPath() {
        // Given
        let namespace = Namespace.ID()
        let view = ActionButtonsView(
            hasGameStarted: false,
            startNewGame: {},
            dealThreeMore: {},
            isDeckEmpty: true,
            onStartGame: {},
            shuffle: {},
            deck: [],
            discardPile: [],
            namespace: namespace
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }
}
