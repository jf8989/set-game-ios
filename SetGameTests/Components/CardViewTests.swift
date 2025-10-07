/// Path: SetGameTests/Components/CardViewTests.swift
/// Role: Exercise CardView branches by touching body under several states

import SwiftUI
import XCTest

@testable import set_game

// MARK: - CardView Rendering tests
final class CardViewTests: XCTestCase {

    // MARK: Helpers

    /// Builds a sample `CardSet` for view tests.
    /// Uses a fresh random UUID by default; ids are not asserted in these tests.
    private func makeCard(number: CardNumber = .one) -> CardSet {
        CardSet(
            id: UUID(),
            color: .red,
            symbol: .diamond,
            shading: .solid,
            number: number
        )
    }

    // MARK: Not selected / none
    func testCardView_NotSelected_NoneState_ComputesBody() {
        // Given: a non-selected card with `.none` evaluation state.
        let cardUnderTest = makeCard()
        let cardView = CardView(
            card: cardUnderTest,
            isSelected: false,
            setEvalStatus: .none,
            namespace: TestNamespaceShim.id
        )

        // When: computing the view body (touches conditional rendering and styles).
        _ = cardView.body

        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    // MARK: Selected / found
    func testCardView_Selected_FoundState_ComputesBody() {
        // Given: a selected card with `.found` evaluation state.
        let cardUnderTest = makeCard(number: .three)
        let cardView = CardView(
            card: cardUnderTest,
            isSelected: true,
            setEvalStatus: .found,
            namespace: TestNamespaceShim.id
        )

        // When: computing the view body.
        _ = cardView.body

        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }

    // MARK: Selected / fail
    func testCardView_Selected_FailState_ComputesBody() {
        // Given: a selected card with `.fail` evaluation state.
        let cardUnderTest = makeCard(number: .two)
        let cardView = CardView(
            card: cardUnderTest,
            isSelected: true,
            setEvalStatus: .fail,
            namespace: TestNamespaceShim.id
        )

        // When: computing the view body.
        _ = cardView.body

        // Then: body computation succeeds without crash (sanity; no snapshot assertions).
        XCTAssertTrue(true)
    }
}
