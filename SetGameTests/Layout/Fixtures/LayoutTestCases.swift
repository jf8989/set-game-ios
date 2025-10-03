/// Path: SetGameTests/Layout/Fixtures/LayoutTestCases.swift
/// Role: Reusable constants for layout tests (no abbreviations, descriptive names)

import CoreGraphics

enum LayoutTestCases {
    // Common aspect ratios used by the product grid
    static let aspectRatioTwoThirds: CGFloat = 2.0 / 3.0

    // Container sizes to simulate devices and orientations
    static let containerSizePhonePortrait = CGSize(width: 360, height: 640)
    static let containerSizePhoneLandscape = CGSize(width: 640, height: 360)
    static let containerSizeTabletPortrait = CGSize(width: 768, height: 1024)
    static let containerSizeTabletLandscape = CGSize(width: 1024, height: 768)

    // Representative item-count scenarios
    static let itemCounts: [Int] = [0, 1, 3, 9, 12, 15, 24]
}
