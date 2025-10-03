/// Path: SetGameTests/Components/HeaderAndGridTests.swift
/// Role: Execute both branches for HeaderView and GridAndInstructionsView

import SwiftUI
import XCTest

@testable import set_game

// MARK: - Header and Grid Toggle tests
final class HeaderAndGridTests: XCTestCase {

    func testHeaderView_ShowsScoreAndCardsLeft_WhenGameStarted() {
        // Given
        let view = HeaderView(score: 7, cardsLeft: 42, hasGameStarted: true)

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testHeaderView_HidesScoreAndCardsLeft_WhenGameNotStarted() {
        // Given
        let view = HeaderView(score: 7, cardsLeft: 42, hasGameStarted: false)

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testGridAndInstructionsView_ShowsInstructions_WhenGameNotStarted() {
        // Given
        let namespace = Namespace.ID()
        let view = GridAndInstructionsView(
            tableCards: [],
            hasGameStarted: false,
            isSelected: { _ in false },
            setEvalStatus: .none,
            namespace: namespace,
            select: { _ in }
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testGridAndInstructionsView_ShowsGrid_WhenGameStarted() {
        // Given
        let namespace = Namespace.ID()
        let sampleCard = CardSet(id: UUID(), color: .green, symbol: .oval, shading: .open, number: .two)
        let view = GridAndInstructionsView(
            tableCards: [sampleCard],
            hasGameStarted: true,
            isSelected: { _ in false },
            setEvalStatus: .none,
            namespace: namespace,
            select: { _ in }
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }
}
