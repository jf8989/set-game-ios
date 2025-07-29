// Model/SetCard.swift

import Foundation

enum CardColor: CaseIterable {
    case red, green, purple
}

enum CardSymbol: CaseIterable {
    case diamond, oval, squiggle
}

enum CardShading: CaseIterable {
    case solid, open, striped
}

enum CardNumber: CaseIterable {
    case one, two, three
}

struct SetCard: Identifiable {
    var id: UUID
    var color: CardColor
    var symbol: CardSymbol
    var shading: CardShading
    var number: CardNumber
}
