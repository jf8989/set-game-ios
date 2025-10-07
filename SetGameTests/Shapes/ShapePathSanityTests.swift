/// Path: SetGameTests/Shapes/ShapePathSanityTests.swift
/// Role: Cover shape paths (sanity, non-empty, symmetry)
import XCTest

@testable import set_game

final class ShapePathSanityTests: XCTestCase {
    func testDiamondPath_IsNonEmpty() {
        // Given: a drawing rectangle for the shape path.
        let drawingRectangle = CGRect(x: 0, y: 0, width: 100, height: 50)
        // When: building the path for a Diamond shape within the rectangle.
        let path = Diamond().path(in: drawingRectangle)
        // Then: the resulting path is not empty (sanity check; no visual assertions).
        XCTAssertFalse(path.isEmpty)
    }

    func testOvalPath_IsNonEmpty() {
        // Given: a drawing rectangle for the shape path.
        let drawingRectangle = CGRect(x: 0, y: 0, width: 80, height: 40)
        // When: building the path for an Oval shape within the rectangle.
        let path = Oval().path(in: drawingRectangle)
        // Then: the resulting path is not empty (sanity check; no visual assertions).
        XCTAssertFalse(path.isEmpty)
    }

    func testSquigglePath_IsNonEmpty() {
        // Given: a drawing rectangle for the shape path.
        let drawingRectangle = CGRect(x: 0, y: 0, width: 120, height: 60)
        // When: building the path for a Squiggle shape within the rectangle.
        let path = Squiggle().path(in: drawingRectangle)
        // Then: the resulting path is not empty (sanity check; no visual assertions).
        XCTAssertFalse(path.isEmpty)
    }
}
