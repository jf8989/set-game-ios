// Model/SetCard.swift

import Foundation

// MARK: - Card Attributes

enum CardColor: CaseIterable {
    case red, green, purple
}

enum CardSymbol: String, CaseIterable {
    case diamond = "◆"
    case oval = "●"
    case squiggle = "≃"
}

enum CardShading: CaseIterable {
    case solid, open, striped
}

enum CardNumber: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
}

// MARK: - Card Structure
/// Identifiable + Equatable so SwiftUI diffing & .animation(value:) work.
struct SetCard: Identifiable, Equatable {
    var id: UUID
    var color: CardColor
    var symbol: CardSymbol
    var shading: CardShading
    var number: CardNumber
}
