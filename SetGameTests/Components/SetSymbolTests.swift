/// Path: SetGameTests/Components/SetSymbolTests.swift
/// Role: Cover SetSymbolView shading branches and geometry switch (single class)

import SwiftUI
import XCTest

@testable import set_game

// MARK: - SetSymbol tests
final class SetSymbolTests: XCTestCase {

    // MARK: Rendering choice
    func testSymbolShadingBranches_ExecuteWithoutCrash() {
        let shadings: [CardShading] = [.solid, .open, .striped]
        for shading in shadings {
            let view = SetSymbolView(symbol: .diamond, color: .red, shading: shading)
            _ = view.body  // touches the switch; not snapshot-testing
            XCTAssertTrue(true)
        }
    }

    // MARK: Geometry + all symbols/shadings
    func testSetSymbolView_AllSymbols_AllShadings_ComputesBody() {
        // Given
        let symbols: [CardSymbol] = [.diamond, .oval, .squiggle]
        let shadings: [CardShading] = [.solid, .open, .striped]

        for symbol in symbols {
            for shading in shadings {
                let view = SetSymbolView(
                    symbol: symbol,
                    color: .red,
                    shading: shading
                )
                // When
                _ = view.body
                // Then
                XCTAssertTrue(true)
            }
        }
    }
}
