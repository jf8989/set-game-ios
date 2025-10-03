/// Path: SetGameTests/Helpers/CardColorUIMappingTests.swift
/// Role: Cover UI color mapping for all card colors

import XCTest

@testable import set_game

final class CardColorUIMappingTests: XCTestCase {
    func testAllCardColors_HaveUIColor() {
        // Given
        let allColors: [CardColor] = [.red, .green, .purple]
        // When/Then
        for color in allColors {
            XCTAssertNotNil(color.uiColor)
        }
    }
}
