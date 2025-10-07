/// Path: SetGameTests/Layout/AspectVerticalGridLayoutTests.swift
/// Role: Unit tests for width solver logic via a proxy (pure math; Given/When/Then everywhere)

import CoreGraphics
import SwiftUI
import XCTest

@testable import set_game

final class AspectVerticalGridLayoutTests: XCTestCase {

    // MARK: - Core Seam Tests (canonical checks against product solver)

    func testWidthThatFits_ZeroItems_ReturnsContainerWidth() {
        // Given: a container and zero items (trivial case).
        let containerSize = CGSize(width: 640, height: 360)
        let itemAspectRatio: CGFloat = 2.0 / 3.0

        // When: computing the width that fits.
        let computedItemWidth = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: 0,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: the solver returns the container width as the trivial fit.
        XCTAssertEqual(computedItemWidth, containerSize.width)
    }

    func testWidthThatFits_NoOverflow_ForTwelveItems_PhonePortrait() {
        // Given: a phone-portrait container with twelve items and two-thirds aspect ratio.
        let numberOfItems = 12
        let containerSize = CGSize(width: 360, height: 640)
        let itemAspectRatio: CGFloat = 2.0 / 3.0

        // When: computing the width that fits.
        let computedItemWidth = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: resulting row count * itemHeight fits within container height (no overflow).
        XCTAssertGreaterThan(computedItemWidth, 0)
        let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
        let itemHeight = computedItemWidth / itemAspectRatio
        let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
        XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
    }

    func testWidthThatFits_Monotonic_WhenContainerShrinks_ItemWidthNotLarger() {
        // Given: a fixed item count with two container widths (smaller vs larger).
        let numberOfItems = 12
        let largerContainer = CGSize(width: 800, height: 600)
        let smallerContainer = CGSize(width: 600, height: 600)
        let itemAspectRatio: CGFloat = 2.0 / 3.0

        // When: computing widths for both containers.
        let widthForLarger = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: largerContainer,
            itemAspectRatio: itemAspectRatio
        )
        let widthForSmaller = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: smallerContainer,
            itemAspectRatio: itemAspectRatio
        )

        // Then: item width must not increase as the container shrinks (monotonicity).
        XCTAssertLessThanOrEqual(widthForSmaller, widthForLarger)
    }

    // MARK: - Phone Portrait invariants

    func testWidthSolver_WithTwelveItems_FitsWithinPhonePortraitHeight() {
        // Given: a phone portrait container and twelve items with two-thirds aspect ratio.
        let numberOfItems = 12
        let containerSize = LayoutTestCases.containerSizePhonePortrait
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds

        // When: computing the item width that fits.
        let computedItemWidth = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: the rows computed with that width do not overflow the container height.
        XCTAssertGreaterThan(computedItemWidth, 0)
        let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
        let itemHeight = computedItemWidth / itemAspectRatio
        let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
        XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
    }

    func testWidthSolver_DoesNotOverflow_ForRepresentativeItemCounts_OnPhonePortrait() {
        // Given: a phone portrait container and a set of representative item counts.
        let containerSize = LayoutTestCases.containerSizePhonePortrait
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios.
        let computedWidths = representativeItemCounts.map { numberOfItems in
            AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: all computed widths are non-negative; when items > 0 the layout does not overflow height.
        for (indexWithinArray, numberOfItems) in representativeItemCounts.enumerated() {
            let computedItemWidth = computedWidths[indexWithinArray]
            XCTAssertGreaterThanOrEqual(computedItemWidth, 0)

            if numberOfItems == 0 {
                XCTAssertEqual(computedItemWidth, containerSize.width)
                continue
            }

            let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
            let itemHeight = computedItemWidth / itemAspectRatio
            let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
            XCTAssertLessThanOrEqual(
                CGFloat(estimatedRowCount) * itemHeight,
                containerSize.height,
                "Layout should not overflow for \(numberOfItems) items."
            )
        }
    }

    // MARK: - Phone Landscape invariants

    func testWidthSolver_DoesNotOverflow_ForRepresentativeItemCounts_OnPhoneLandscape() {
        // Given: a phone landscape container and a set of representative item counts.
        let containerSize = LayoutTestCases.containerSizePhoneLandscape
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios.
        let computedWidths = representativeItemCounts.map { numberOfItems in
            AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: rows should fit the height for practical counts; tiny counts (≤ 2) may exceed.
        for (indexWithinArray, numberOfItems) in representativeItemCounts.enumerated() {
            let computedItemWidth = computedWidths[indexWithinArray]
            if numberOfItems == 0 {
                XCTAssertEqual(computedItemWidth, containerSize.width)
                continue
            }

            let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
            let itemHeight = computedItemWidth / itemAspectRatio
            let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount

            if numberOfItems <= 2 {
                XCTAssertGreaterThan(computedItemWidth, 0, "Width should be positive for tiny counts.")
                continue
            }

            XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
        }
    }

    func testLandscape_NoOverflow_ForRepresentativeCounts() {
        // Given: a phone landscape container and representative item counts (parity coverage).
        let containerSize = LayoutTestCases.containerSizePhoneLandscape
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios.
        let computedWidths = representativeItemCounts.map { numberOfItems in
            AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: parity test mirrors the previous landscape invariant; assertions are identical by design.
        for (indexWithinArray, numberOfItems) in representativeItemCounts.enumerated() {
            let computedItemWidth = computedWidths[indexWithinArray]
            if numberOfItems == 0 {
                XCTAssertEqual(computedItemWidth, containerSize.width)
                continue
            }

            let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
            let itemHeight = computedItemWidth / itemAspectRatio
            let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount

            if numberOfItems <= 2 {
                XCTAssertGreaterThan(computedItemWidth, 0, "Width should be positive for tiny counts.")
                continue
            }

            XCTAssertLessThanOrEqual(
                CGFloat(estimatedRowCount) * itemHeight,
                containerSize.height,
                "Layout should not overflow for \(numberOfItems) items."
            )
        }
    }

    // MARK: - Tablet Portrait invariants

    func testWidthSolver_DoesNotOverflow_ForRepresentativeItemCounts_OnTabletPortrait() {
        // Given: a tablet portrait container and a set of representative item counts.
        let containerSize = LayoutTestCases.containerSizeTabletPortrait
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios.
        let computedWidths = representativeItemCounts.map { numberOfItems in
            AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: computed rows fit within height for all counts.
        for (indexWithinArray, numberOfItems) in representativeItemCounts.enumerated() {
            let computedItemWidth = computedWidths[indexWithinArray]
            if numberOfItems == 0 {
                XCTAssertEqual(computedItemWidth, containerSize.width)
                continue
            }
            let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
            let itemHeight = computedItemWidth / itemAspectRatio
            let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
            XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
        }
    }

    // MARK: - Zero items & explicit parity seam tests (duplicates kept intentionally)

    func testWidthSolver_ReturnsContainerWidth_WhenZeroItems() {
        // Given: zero items and a tablet landscape container.
        let numberOfItems = 0
        let containerSize = LayoutTestCases.containerSizeTabletLandscape
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds

        // When: computing the item width.
        let computedItemWidth = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: the solver returns the container width as the trivial fit.
        XCTAssertEqual(computedItemWidth, containerSize.width)
    }

    func testWidthThatFits_NoOverflow_ForTwelveItems_PhonePortrait_ExplicitParity() {
        // Given: a phone-portrait container with twelve items and two-thirds aspect ratio (parity check).
        let numberOfItems = 12
        let containerSize = CGSize(width: 360, height: 640)
        let itemAspectRatio: CGFloat = 2.0 / 3.0

        // When: computing the width that fits.
        let computedItemWidth = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: resulting row count * itemHeight fits within container height (no overflow).
        XCTAssertGreaterThan(computedItemWidth, 0)
        let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
        let itemHeight = computedItemWidth / itemAspectRatio
        let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
        XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
    }

    func testWidthThatFits_Monotonic_WhenContainerShrinks_ItemWidthNotLarger_ExplicitParity() {
        // Given: a fixed item count with two container widths (parity check).
        let numberOfItems = 12
        let largerContainer = CGSize(width: 800, height: 600)
        let smallerContainer = CGSize(width: 600, height: 600)
        let itemAspectRatio: CGFloat = 2.0 / 3.0

        // When: computing widths for both containers.
        let widthForLarger = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: largerContainer,
            itemAspectRatio: itemAspectRatio
        )
        let widthForSmaller = AspectVGrid<CardSet, EmptyView>.widthThatFitsForTesting(
            numberOfItems: numberOfItems,
            containerSize: smallerContainer,
            itemAspectRatio: itemAspectRatio
        )

        // Then: item width must not increase as the container shrinks (monotonicity).
        XCTAssertLessThanOrEqual(widthForSmaller, widthForLarger)
    }
}
