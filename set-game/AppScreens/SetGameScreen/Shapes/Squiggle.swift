// View/Shapes/Squiggle.swift

import SwiftUI

/// Simple wavy squiggle shape.
struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY
        let amp = rect.height * 0.30
        path.move(to: CGPoint(x: rect.minX, y: midY + amp))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: midY - amp),
            control1: CGPoint(x: rect.width * 0.35, y: midY + 2 * amp),
            control2: CGPoint(x: rect.width * 0.65, y: midY - 2 * amp)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX, y: midY + amp),
            control1: CGPoint(x: rect.width * 0.65, y: midY + 2 * amp),
            control2: CGPoint(x: rect.width * 0.35, y: midY - 2 * amp)
        )
        return path
    }
}

#Preview {
    Squiggle()
}
