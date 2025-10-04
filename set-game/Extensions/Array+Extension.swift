/// Path: set-game/Extensions/Array+Extension.swift
/// Role: Set evaluation helpers (now referencing model-scoped rule)

import Foundation

// MARK: - Set Evaluation Helpers

/// Evaluates if a card is a set
extension Array where Element == CardSet {
    var isSet: Bool {
        // Use model-scoped rule instead of a magic number.
        guard self.count == SetGameRules.Rules.selectionTargetCount else { return false }
        let colors = self.map { $0.color }
        let symbols = self.map { $0.symbol }
        let numbers = self.map { $0.number.rawValue }
        let shadings = self.map { $0.shading }

        return colors.allSameOrAllDifferent
            && symbols.allSameOrAllDifferent
            && numbers.allSameOrAllDifferent
            && shadings.allSameOrAllDifferent
    }
}

extension Array where Element: Hashable {
    var allSameOrAllDifferent: Bool {
        let unique = Set(self)
        return unique.count == 1 || unique.count == self.count
    }
}
