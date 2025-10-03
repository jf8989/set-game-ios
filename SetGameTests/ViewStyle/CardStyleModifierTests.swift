/// Path: SetGameTests/ViewStyle/CardStyleModifierTests.swift
/// Role: Cover card style modifier execution (use real signature)

import SwiftUI
import XCTest

@testable import set_game

final class CardStyleModifierTests: XCTestCase {
    func testCardStyleModifier_AppliesWithoutCrash() {
        // Given
        let text = Text("Hello")
        // When (real API: borderColor + isSelected)
        _ = text.cardStyle(borderColor: .blue, isSelected: true)
        // Then
        XCTAssertTrue(true)
    }
}
