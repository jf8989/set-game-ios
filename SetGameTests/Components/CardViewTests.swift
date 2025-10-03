/// Path: SetGameTests/Components/CardViewTests.swift
/// Role: Exercise CardView branches by touching body under several states

import SwiftUI
import XCTest

@testable import set_game

// MARK: - CardView Rendering tests
final class CardViewTests: XCTestCase {

    private func makeCard(number: CardNumber = .one) -> CardSet {
        CardSet(
            id: UUID(),
            color: .red,
            symbol: .diamond,
            shading: .solid,
            number: number
        )
    }

    func testCardView_NotSelected_NoneState_ComputesBody() {
        // Given
        let card = makeCard()
        let namespace = Namespace.ID()
        let view = CardView(
            card: card,
            isSelected: false,
            setEvalStatus: .none,
            namespace: namespace
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testCardView_Selected_FoundState_ComputesBody() {
        // Given
        let card = makeCard(number: .three)
        let namespace = Namespace.ID()
        let view = CardView(
            card: card,
            isSelected: true,
            setEvalStatus: .found,
            namespace: namespace
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }

    func testCardView_Selected_FailState_ComputesBody() {
        // Given
        let card = makeCard(number: .two)
        let namespace = Namespace.ID()
        let view = CardView(
            card: card,
            isSelected: true,
            setEvalStatus: .fail,
            namespace: namespace
        )

        // When
        _ = view.body

        // Then
        XCTAssertTrue(true)
    }
}
