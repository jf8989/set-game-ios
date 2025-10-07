/// Path: set-game/Module/Shapes/Squiggle.swift
/// Role: Theme-driven amplitude factor

import SwiftUI

/// Wavy squiggle whose curvature is controlled by parameters.
/// Default parameters preserve the previous look-and-feel.
struct Squiggle: Shape {

    struct Parameters: Equatable {
        /// Horizontal factors (0…1) for the two cubic Bezier control points.
        let controlXLeadingFactor: CGFloat
        let controlXTrailingFactor: CGFloat
        /// Multiplier applied to vertical control offset relative to amplitude.
        let controlAmplitudeMultiplier: CGFloat
    }

    /// Geometry configuration; defaults to theme-selected personality.
    var parameters: Parameters = SetGameTheme.squiggleParametersCurrent

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let amplitude = rect.height * SetGameTheme.squiggleAmplitudeFactor
        let middleY = rect.midY

        let controlXLeading = rect.width * parameters.controlXLeadingFactor
        let controlXTrailing = rect.width * parameters.controlXTrailingFactor
        let verticalControlOffset = parameters.controlAmplitudeMultiplier * amplitude

        path.move(to: CGPoint(x: rect.minX, y: middleY + amplitude))

        // First half wave: left → right
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: middleY - amplitude),
            control1: CGPoint(x: controlXLeading, y: middleY + verticalControlOffset),
            control2: CGPoint(x: controlXTrailing, y: middleY - verticalControlOffset)
        )

        // Second half wave: right → left (mirror back)
        path.addCurve(
            to: CGPoint(x: rect.minX, y: middleY + amplitude),
            control1: CGPoint(x: controlXTrailing, y: middleY + verticalControlOffset),
            control2: CGPoint(x: controlXLeading, y: middleY - verticalControlOffset)
        )

        return path
    }
}

#Preview {
    VStack(spacing: 16) {
        // Default (matches previous visuals)
        Squiggle()
            .stroke(.blue, lineWidth: 2)
            .frame(width: 240, height: 100)

        // Example: alternate personalities
        Squiggle(parameters: SetGameTheme.squiggleParametersPlayful)
            .stroke(.green, lineWidth: 2)
            .frame(width: 240, height: 100)

        Squiggle(parameters: SetGameTheme.squiggleParametersFormal)
            .stroke(.purple, lineWidth: 2)
            .frame(width: 240, height: 100)
    }
    .padding()
}
