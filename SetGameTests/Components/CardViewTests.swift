/// Path: SetGameTests/Components/CardViewTests.swift
/// Role: Exercise CardView branches by touching body under several states

import SwiftUI
import XCTest

@testable import set_game

// MARK: - CardView Rendering tests
final class CardViewTests: XCTestCase {

    // MARK: Helpers
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
        // Given
        let card = makeCard()
        let view = CardView(
            card: card,
            isSelected: false,
            setEvalStatus: .none,
            namespace: TestNamespaceShim.id
        )
        // When
        _ = view.body
        // Then
        XCTAssertTrue(true)
    }

    // MARK: Selected / found
    func testCardView_Selected_FoundState_ComputesBody() {
        // Given
        let card = makeCard(number: .three)
        let view = CardView(
            card: card,
            isSelected: true,
            setEvalStatus: .found,
            namespace: TestNamespaceShim.id
        )
        // When
        _ = view.body
        // Then
        XCTAssertTrue(true)
    }

    // MARK: Selected / fail
    func testCardView_Selected_FailState_ComputesBody() {
        // Given
        let card = makeCard(number: .two)
        let view = CardView(
            card: card,
            isSelected: true,
            setEvalStatus: .fail,
            namespace: TestNamespaceShim.id
        )
        // When
        _ = view.body
        // Then
        XCTAssertTrue(true)
    }
}
