/// Path: Extensions/CardColor+UI.swift
/// Role: Domain→UI mapping; tiny, justified extension per checklist

import SwiftUI

extension CardColor {
    /// UI mapping for card colors. If theming arrives later, this becomes a token lookup.
    var uiColor: Color {
        switch self {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
}
