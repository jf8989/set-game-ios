/// Path: SetGameTests/Helpers/CardColorUIMappingTests.swift
/// Role: Cover UI color mapping for all card colors

import XCTest

@testable import set_game

final class CardColorUIMappingTests: XCTestCase {
    func testAllCardColors_HaveUIColorMapping() {
        // Given: all supported card colors in the domain.
        let allCardColors: [CardColor] = [.red, .green, .purple]

        // When: retrieving the UIKit color mapping for each domain color.
        // Then: every color must have a non-nil `uiColor` mapping.
        for cardColor in allCardColors {
            XCTAssertNotNil(
                cardColor.uiColor,
                "Missing UI color mapping for domain color: \(cardColor)"
            )
        }
    }
}
