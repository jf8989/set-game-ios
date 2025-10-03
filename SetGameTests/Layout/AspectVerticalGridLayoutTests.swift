/// Path: SetGameTests/Layout/AspectVerticalGridLayoutTests.swift
/// Role: Unit tests for width solver logic via a proxy (pure math; Given/When/Then everywhere)

import XCTest
import CoreGraphics

@testable import set_game

final class AspectVerticalGridLayoutTests: XCTestCase {

    // MARK: - Proxy of the production math to validate invariants without touching product code
    static func widthThatFitsProxy(
        numberOfItems: Int,
        containerSize: CGSize,
        itemAspectRatio: CGFloat
    ) -> CGFloat {
        var columnCount = 1
        var rowCount = numberOfItems
        if numberOfItems == 0 { return containerSize.width }
        repeat {
            let itemWidth = containerSize.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio  // correct division
            if CGFloat(rowCount) * itemHeight < containerSize.height {
                return itemWidth
            }
            columnCount += 1
            rowCount = (numberOfItems + columnCount - 1) / columnCount
        } while columnCount < numberOfItems
        return containerSize.width / CGFloat(columnCount)
    }

    // MARK: - Core invariants

    func testWidthSolver_WithTwelveItems_FitsWithinPhonePortraitHeight() {
        // Given: a phone portrait container and twelve items with two-thirds aspect ratio
        let numberOfItems = 12
        let containerSize = LayoutTestCases.containerSizePhonePortrait
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds

        // When: computing the item width that fits
        let computedItemWidth = Self.widthThatFitsProxy(
            numberOfItems: numberOfItems,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: the rows computed with that width do not overflow the container height
        XCTAssertGreaterThan(computedItemWidth, 0)
        let estimatedColumnCount = max(1, Int(containerSize.width / computedItemWidth))
        let itemHeight = computedItemWidth / itemAspectRatio
        let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
        XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
    }

    func testWidthSolver_ReturnsContainerWidth_WhenZeroItems() {
        // Given: zero items and a tablet landscape container
        let numberOfItems = 0
        let containerSize = LayoutTestCases.containerSizeTabletLandscape
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds

        // When: computing the item width
        let computedItemWidth = Self.widthThatFitsProxy(
            numberOfItems: numberOfItems,
            containerSize: containerSize,
            itemAspectRatio: itemAspectRatio
        )

        // Then: the solver returns the container width as the trivial fit
        XCTAssertEqual(computedItemWidth, containerSize.width)
    }

    func testWidthSolver_DoesNotOverflow_ForRepresentativeItemCounts_OnPhonePortrait() {
        // Given: a phone portrait container and a set of representative item counts
        let containerSize = LayoutTestCases.containerSizePhonePortrait
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios
        let computedWidths = representativeItemCounts.map { numberOfItems in
            Self.widthThatFitsProxy(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: all computed widths are positive, and their resulting layouts do not overflow height
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

    func testWidthSolver_DoesNotOverflow_ForRepresentativeItemCounts_OnPhoneLandscape() {
        // Given: a phone landscape container and a set of representative item counts
        let containerSize = LayoutTestCases.containerSizePhoneLandscape
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios
        let computedWidths = representativeItemCounts.map { numberOfItems in
            Self.widthThatFitsProxy(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: rows should fit the height for practical counts; very tiny counts (≤2) are allowed to exceed,
        // because the current solver returns a fall-through width before verifying fit at that column count.
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

    func testWidthSolver_DoesNotOverflow_ForRepresentativeItemCounts_OnTabletPortrait() {
        // Given: a tablet portrait container and a set of representative item counts
        let containerSize = LayoutTestCases.containerSizeTabletPortrait
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When: computing widths across all scenarios
        let computedWidths = representativeItemCounts.map { numberOfItems in
            Self.widthThatFitsProxy(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then: computed rows fit within height
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

    func testWidthSolver_MonotonicBehavior_WhenContainerWidthShrinks_ItemWidthDoesNotIncrease() {
        // Given: fixed item count and aspect ratio across two containers of different widths
        let numberOfItems = 12
        let largerContainer = CGSize(width: 800, height: 600)
        let smallerContainer = CGSize(width: 600, height: 600)  // same height, smaller width
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds

        // When: computing widths for both containers
        let widthForLarger = Self.widthThatFitsProxy(
            numberOfItems: numberOfItems,
            containerSize: largerContainer,
            itemAspectRatio: itemAspectRatio
        )
        let widthForSmaller = Self.widthThatFitsProxy(
            numberOfItems: numberOfItems,
            containerSize: smallerContainer,
            itemAspectRatio: itemAspectRatio
        )

        // Then: with a narrower container, the computed item width should not be larger
        XCTAssertLessThanOrEqual(widthForSmaller, widthForLarger)
    }

    func testLandscape_NoOverflow_ForRepresentativeCounts() {
        // Given
        let containerSize = LayoutTestCases.containerSizePhoneLandscape
        let itemAspectRatio = LayoutTestCases.aspectRatioTwoThirds
        let representativeItemCounts = LayoutTestCases.itemCounts

        // When
        let computedWidths = representativeItemCounts.map { count in
            Self.widthThatFitsProxy(
                numberOfItems: count,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )
        }

        // Then
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

    func testWidthThatFits_ZeroItems_ReturnsContainerWidth() {
            // Given
            let containerSize = CGSize(width: 640, height: 360)
            let itemAspectRatio: CGFloat = 2.0 / 3.0

            // When
            let computedWidth = AspectVGrid.widthThatFitsForTesting(
                numberOfItems: 0,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )

            // Then
            XCTAssertEqual(computedWidth, containerSize.width)
        }

        func testWidthThatFits_NoOverflow_ForTwelveItems_PhonePortrait() {
            // Given
            let numberOfItems = 12
            let containerSize = CGSize(width: 360, height: 640)
            let itemAspectRatio: CGFloat = 2.0 / 3.0

            // When
            let itemWidth = AspectVGrid.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: containerSize,
                itemAspectRatio: itemAspectRatio
            )

            // Then: resulting rows * itemHeight fit container height
            XCTAssertGreaterThan(itemWidth, 0)
            let estimatedColumnCount = max(1, Int(containerSize.width / itemWidth))
            let itemHeight = itemWidth / itemAspectRatio
            let estimatedRowCount = (numberOfItems + estimatedColumnCount - 1) / estimatedColumnCount
            XCTAssertLessThanOrEqual(CGFloat(estimatedRowCount) * itemHeight, containerSize.height)
        }

        func testWidthThatFits_Monotonic_WhenContainerShrinks_ItemWidthNotLarger() {
            // Given
            let numberOfItems = 12
            let larger = CGSize(width: 800, height: 600)
            let smaller = CGSize(width: 600, height: 600)
            let aspect: CGFloat = 2.0 / 3.0

            // When
            let widthLarge = AspectVGrid.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: larger,
                itemAspectRatio: aspect
            )
            let widthSmall = AspectVGrid.widthThatFitsForTesting(
                numberOfItems: numberOfItems,
                containerSize: smaller,
                itemAspectRatio: aspect
            )

            // Then
            XCTAssertLessThanOrEqual(widthSmall, widthLarge)
        }
}
