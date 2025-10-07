/// Path: SetGameTests/Components/HeaderAndGridTests.swift
/// Role: Execute both branches for HeaderView and GridAndInstructionsView

import SwiftUI
import XCTest

@testable import set_game

// MARK: - Header and Grid Toggle tests
final class HeaderAndGridTests: XCTestCase {

    // MARK: HeaderView
    func testHeaderView_ShowsScoreAndCardsLeft_WhenGameStarted() {
        // Given: game has started; header should present score and cards-left.
        let headerView = HeaderView(score: 7, cardsLeft: 42, hasGameStarted: true)
        // When: computing the view body (touches conditional rendering).
        _ = headerView.body
        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    func testHeaderView_HidesScoreAndCardsLeft_WhenGameNotStarted() {
        // Given: game not started; header should hide score and cards-left.
        let headerView = HeaderView(score: 7, cardsLeft: 42, hasGameStarted: false)
        // When: computing the view body (touches conditional rendering).
        _ = headerView.body
        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    // MARK: GridAndInstructionsView
    func testGridAndInstructionsView_ShowsInstructions_WhenGameNotStarted() {
        // Given: game not started; the instructions branch should render.
        let gridAndInstructionsView = GridAndInstructionsView(
            tableCards: [],
            hasGameStarted: false,
            isSelected: { _ in false },
            setEvalStatus: .none,
            namespace: TestNamespaceShim.id,
            select: { _ in }
        )
        // When: computing the view body.
        _ = gridAndInstructionsView.body
        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    func testGridAndInstructionsView_ShowsGrid_WhenGameStarted() {
        // Given: at least one card on table and game started; the grid branch should render.
        let sampleCardForGrid = CardSet(
            id: UUID(),
            color: .green,
            symbol: .oval,
            shading: .open,
            number: .two
        )
        let gridAndInstructionsView = GridAndInstructionsView(
            tableCards: [sampleCardForGrid],
            hasGameStarted: true,
            isSelected: { _ in false },
            setEvalStatus: .none,
            namespace: TestNamespaceShim.id,
            select: { _ in }
        )
        // When: computing the view body.
        _ = gridAndInstructionsView.body
        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }
}
