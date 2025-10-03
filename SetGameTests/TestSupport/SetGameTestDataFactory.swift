/// Path: SetGameTests/TestSupport/Builders/SetGameTestDataFactory.swift
/// Role: Shared builders for deterministic Set Game test data

import Foundation

@testable import set_game

/// Provides factory methods to construct predictable `SetGameRules` instances
/// for unit tests without duplicating setup logic in every test file.
enum SetGameTestDataFactory {

    /// Builds a rules instance with known table cards and an optional deck remainder.
    /// - Parameters:
    ///   - tableCards: The exact cards to place on the table at test start.
    ///   - deckRemainder: The remaining deck to seed for subsequent actions (defaults to empty).
    /// - Returns: A `SetGameRules` configured for deterministic testing.
    static func makeGameWithKnownTable(
        tableCards: [CardSet],
        deckRemainder: [CardSet] = []
    ) -> SetGameRules {
        var gameRules = SetGameRules()
        gameRules.tableCards = tableCards
        gameRules.deck = deckRemainder
        gameRules.selectedCards.removeAll()
        gameRules.setEvalStatus = .none
        gameRules.score = 0
        gameRules.discardPile.removeAll()
        return gameRules
    }
}
