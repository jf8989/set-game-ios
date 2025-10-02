// View/Modifiers/CardStyle.swift

import SwiftUI

// This struct defines the actual visual changes for my card style.
struct CardStyle: ViewModifier {
    let borderColor: Color
    let isSelected: Bool

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 18)
            shape.fill(Color(.systemBackground))  // Use system background for light/dark mode
            shape.stroke(borderColor, lineWidth: isSelected ? 4 : 2)
            content  // This is where the view I'm modifying will be placed.
        }
    }
}

// This extension makes my new modifier easy to use, like any other built-in modifier.
extension View {
    func cardStyle(borderColor: Color, isSelected: Bool) -> some View {
        self.modifier(
            CardStyle(borderColor: borderColor, isSelected: isSelected)
        )
    }
}
