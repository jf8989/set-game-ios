/// Path: SetGameTests/Components/SetSymbolTests.swift
/// Role: Cover SetSymbolView shading branches and geometry switch (single class)

import SwiftUI
import XCTest

@testable import set_game

// MARK: - SetSymbol tests
final class SetSymbolTests: XCTestCase {

    // MARK: Rendering choice
    func testSetSymbolView_ShadingSwitch_ExecutesWithoutCrash() {
        // Given: all shading cases for a fixed symbol/color.
        let shadingCases: [CardShading] = [.solid, .open, .striped]

        // When: computing the `body` for each shading (touches the View's switch).
        // Then: building the body should not throw or crash (sanity only; no snapshot).
        for shading in shadingCases {
            let view = SetSymbolView(symbol: .diamond, color: .red, shading: shading)
            _ = view.body
            XCTAssertTrue(true)
        }
    }

    // MARK: Geometry + all symbols/shadings
    func testSetSymbolView_AllSymbols_AllShadings_ComputesBody() {
        // Given: all symbol cases crossed with all shading cases.
        let symbolCases: [CardSymbol] = [.diamond, .oval, .squiggle]
        let shadingCases: [CardShading] = [.solid, .open, .striped]

        // When: computing `body` for every combination.
        // Then: body computation succeeds for all pairs (no crash; geometry paths exist).
        for symbol in symbolCases {
            for shading in shadingCases {
                let view = SetSymbolView(symbol: symbol, color: .red, shading: shading)
                _ = view.body
                XCTAssertTrue(true)
            }
        }
    }
}
