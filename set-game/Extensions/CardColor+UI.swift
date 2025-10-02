/// Path: Extensions/CardColor+UI.swift
/// Role: Domain→UI mapping; tiny, justified extension per checklist

import SwiftUI

extension CardColor {
    /// UI mapping for card colors. Uses theme tokens so palette is centralized.
    var uiColor: Color {
        switch self {
        case .red: return SetGameTheme.symbolRed
        case .green: return SetGameTheme.symbolGreen
        case .purple: return SetGameTheme.symbolPurple
        }
    }
}
