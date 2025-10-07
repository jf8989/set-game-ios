/// Path: SetGameTests/Layout/Fixtures/LayoutTestCases.swift
/// Role: Reusable constants for layout tests (no abbreviations, descriptive names)

import CoreGraphics

/// Canonical layout scenarios expressed in **points** (logical coordinates),
/// independent of device pixel density.
enum LayoutTestCases {

    // MARK: Aspect ratios

    /// Two-thirds aspect ratio used by Set cards (width : height = 2 : 3).
    static let aspectRatioTwoThirds: CGFloat = 2.0 / 3.0

    // MARK: Container sizes (points)

    /// Typical phone portrait container (points).
    static let containerSizePhonePortrait = CGSize(width: 360, height: 640)

    /// Typical phone landscape container (points).
    static let containerSizePhoneLandscape = CGSize(width: 640, height: 360)

    /// Typical tablet portrait container (points).
    static let containerSizeTabletPortrait = CGSize(width: 768, height: 1024)

    /// Typical tablet landscape container (points).
    static let containerSizeTabletLandscape = CGSize(width: 1024, height: 768)

    // MARK: Representative item-count scenarios

    /// Common item counts used to probe solver behavior, including the "tiny count" bucket (≤ 2).
    static let itemCounts: [Int] = [0, 1, 2, 3, 9, 12, 15, 24]
}
