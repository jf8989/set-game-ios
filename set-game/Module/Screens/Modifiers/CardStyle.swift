// Core/AppScreens/SetGameScreen/Modifiers/CardStyle.swift

import SwiftUI

// This struct defines the actual visual changes for the card style.
struct CardStyle: ViewModifier {
    let borderColor: Color
    let isSelected: Bool

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: SetGameTheme.cardCornerRadius)
            shape.fill(Color(.systemBackground))
            shape.stroke(
                borderColor,
                lineWidth: isSelected
                    ? SetGameTheme.cardSelectedBorderWidth
                    : SetGameTheme.cardBorderWidth
            )
            content  // This is where the modiefied view will be placed.
        }
    }
}

// This extension makes the new modifier easy to use, like any other built-in modifier.
extension View {
    func cardStyle(borderColor: Color, isSelected: Bool) -> some View {
        self.modifier(
            CardStyle(borderColor: borderColor, isSelected: isSelected)
        )
    }
}
