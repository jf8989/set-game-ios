/// Path: set-game/Module/Shapes/Oval.swift
/// Role: Custom oval shape to keep symbol rendering consistent (custom shapes everywhere)

import SwiftUI

/// An oval equivalent to rendering a capsule with full rounding.
/// Matches prior visuals that used `Capsule()` with a given frame.
struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius = min(rect.width, rect.height) / 2.0
        return Path(roundedRect: rect, cornerRadius: cornerRadius)
    }
}

#Preview {
    VStack(spacing: 16) {
        Oval()
            .fill(.blue.opacity(0.3))
            .frame(width: 160, height: 96)

        Oval()
            .stroke(.blue, lineWidth: 2)
            .frame(width: 160, height: 96)
    }
    .padding()
}
