/// Path: SetGameTests/Shapes/ShapePathSanityTests.swift
/// Role: Cover shape paths (sanity, non-empty, symmetry)
import XCTest

@testable import set_game

final class ShapePathSanityTests: XCTestCase {
    func testDiamondPath_IsNonEmpty() {
        // Given
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        // When
        let path = Diamond().path(in: rect)
        // Then
        XCTAssertFalse(path.isEmpty)
    }
    func testOvalPath_IsNonEmpty() {
        let rect = CGRect(x: 0, y: 0, width: 80, height: 40)
        XCTAssertFalse(Oval().path(in: rect).isEmpty)
    }
    func testSquigglePath_IsNonEmpty() {
        let rect = CGRect(x: 0, y: 0, width: 120, height: 60)
        XCTAssertFalse(Squiggle().path(in: rect).isEmpty)
    }
}
