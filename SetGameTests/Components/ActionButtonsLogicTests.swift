/// Path: SetGameTests/Components/ActionButtonsLogicTests.swift
/// Role: Unit-test ActionButtonsView helpers
import XCTest

@testable import set_game

final class ActionButtonsLogicTests: XCTestCase {
    func testDeckOverlayOpacity_BehavesAsExpected() {
        XCTAssertEqual(ActionButtonsView.deckOverlayOpacity(isDeckEmpty: true), 0.0)
        XCTAssertEqual(ActionButtonsView.deckOverlayOpacity(isDeckEmpty: false), 0.5)
    }
    func testDiscardStrokeOpacity_BehavesAsExpected() {
        XCTAssertEqual(ActionButtonsView.discardStrokeOpacity(isDiscardEmpty: true), 0.0)
        XCTAssertEqual(ActionButtonsView.discardStrokeOpacity(isDiscardEmpty: false), 1.0)
    }
}
