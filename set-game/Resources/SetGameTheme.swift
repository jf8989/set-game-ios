/// Path: set-game/Resources/SetGameTheme.swift
/// Role: Central theme constants for Set Game UI (sizes, factors, mild animation)

import SwiftUI

struct SetGameTheme {
    // Card frame & style
    static let cardCornerRadius: CGFloat = 18.0
    static let cardAspectRatio: CGFloat = 2.0 / 3.0
    static let cardBorderWidth: CGFloat = 2.0
    static let cardSelectedBorderWidth: CGFloat = 4.0

    // Symbol sizing inside a card
    static let symbolWidthFactor: CGFloat = 0.70
    static let symbolHeightFactor: CGFloat = 0.60
    static let symbolVerticalSpacingFactor: CGFloat = 0.05
    static let symbolRowHeightFactor: CGFloat = 0.27

    // Discard / deck preview tiles
    static let miniTileSize = CGSize(width: 80, height: 120)
    static let deckFillColor: Color = .red
    static let discardStrokeLineWidth: CGFloat = 2.0
    static let discardEmptyOpacity: CGFloat = 0.30

    // Controls layout
    static let controlsMaxHeight: CGFloat = 120.0
    static let controlsInterItemSpacing: CGFloat = 22.0
    static let controlsVerticalButtonSpacing: CGFloat = 12.0

    // Visual feedback
    static let setFoundScale: CGFloat = 1.15
    static let setFailRotationDegrees: CGFloat = 4.0
    static let stripedFillOpacity: Double = 0.35

    // Animations
    static let initialDealStep: Double = 0.30
    static let initialDealDuration: Double = 1.00
    static let shuffleSpringResponse: Double = 0.60
    static let shuffleSpringDamping: Double = 0.60

    // Shape parameters
    static let squiggleAmplitudeFactor: CGFloat = 0.30

    // Common opacities / colors
    static let opacityHidden: Double = 0.0
    static let opacityVisible: Double = 1.0
    static let overlayTextColor: Color = .white

    // Symbol colors (domain→UI tokens)
    static let symbolRed: Color = .red
    static let symbolGreen: Color = .green
    static let symbolPurple: Color = .purple

    // MARK: - Grid layout (AspectVGrid) — tokens replacing prior literals
    /// Spacing between rows in the container LazyVGrid.
    static let cardGridContainerSpacing: CGFloat = 0
    /// Spacing between items within a GridItem.
    static let cardGridInterItemSpacing: CGFloat = 0
    /// Seed column count used by width solver.
    static let cardGridInitialColumnCount: Int = 1
    /// Ceiling-division adjust used in row count computation.
    static let cardGridCeilAdjust: Int = -1

    // MARK: - Grid + Instructions UI
    /// Per-card padding inside the grid (was 4).
    static let cardGridItemPadding: CGFloat = 4
    /// Vertical spacing between instruction texts in the VStack (was 8).
    static let instructionsStackSpacing: CGFloat = 8
    /// Max readable width for the instructions block (was 500).
    static let instructionsMaxWidth: CGFloat = 500
    /// Bottom padding under the instructions block (was 6).
    static let instructionsBottomPadding: CGFloat = 6

    // MARK: - Squiggle personalities (geometry presets)
    // Matches the previous hardcoded look: control X at 35% & 65%, vertical control = 2× amplitude.
    static let squiggleParametersDefault = Squiggle.Parameters(
        controlXLeadingFactor: 0.35,
        controlXTrailingFactor: 0.65,
        controlAmplitudeMultiplier: 2.0
    )

    // Slightly looser, more playful curve.
    static let squiggleParametersPlayful = Squiggle.Parameters(
        controlXLeadingFactor: 0.30,
        controlXTrailingFactor: 0.70,
        controlAmplitudeMultiplier: 2.4
    )

    // Tighter, more formal curve with gentler peaks.
    static let squiggleParametersFormal = Squiggle.Parameters(
        controlXLeadingFactor: 0.40,
        controlXTrailingFactor: 0.60,
        controlAmplitudeMultiplier: 1.6
    )

    /// Active squiggle personality. Swap this to change globally.
    static var squiggleParametersCurrent: Squiggle.Parameters {
        squiggleParametersDefault
    }
}
