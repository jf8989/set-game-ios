/// Path: SetGameTests/ViewStyle/CardStyleModifierTests.swift
/// Role: Cover card style modifier execution (use real signature)

import SwiftUI
import XCTest

@testable import set_game

final class CardStyleModifierTests: XCTestCase {
    func testCardStyleModifier_AppliesWithoutCrash() {
        // Given: a concrete Text view ("Hello") and specific style inputs
        //        (borderColor: .blue, isSelected: true).
        let text = Text("Hello")
        // When:  applying the production API `cardStyle(borderColor:isSelected:)`
        //        to the Text to produce a styled View.
        _ = text.cardStyle(borderColor: .blue, isSelected: true)
        // Then:  the modifier composes successfully (no throw / no crash).
        XCTAssertTrue(true)
    }
}
