/// Path: SetGameTests/Components/SetSymbolRenderingChoiceTests.swift
/// Role: Cover SetSymbolView shading branches (correct initializer)

import SwiftUI
import XCTest

@testable import set_game

final class SetSymbolRenderingChoiceTests: XCTestCase {
    func testSymbolShadingBranches_ExecuteWithoutCrash() {
        let shadings: [CardShading] = [.solid, .open, .striped]
        for shading in shadings {
            let view = SetSymbolView(symbol: .diamond, color: .red, shading: shading)
            _ = view.body  // touches the switch; we are not snapshot-testing
            XCTAssertTrue(true)
        }
    }
}
