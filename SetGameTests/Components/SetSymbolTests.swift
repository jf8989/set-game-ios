/// Path: SetGameTests/Components/SetSymbolTests.swift
/// Role: Cover SetSymbolView shading branches (correct initializer)

import SwiftUI
import XCTest

@testable import set_game

// MARK: - SetSymbol Rendering Choice tests
final class SetSymbolTests: XCTestCase {
    func testSymbolShadingBranches_ExecuteWithoutCrash() {
        let shadings: [CardShading] = [.solid, .open, .striped]
        for shading in shadings {
            let view = SetSymbolView(symbol: .diamond, color: .red, shading: shading)
            _ = view.body  // touches the switch; we are not snapshot-testing
            XCTAssertTrue(true)
        }
    }
}

// MARK: - SetSymbol Geometry tests Ext.
extension SetSymbolTests {

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
