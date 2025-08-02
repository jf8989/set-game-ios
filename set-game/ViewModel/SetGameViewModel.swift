// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    // When the model changes, the view will be notified.
    @Published private var model = SetGameModel()

    // MARK: - Properties for the View to Read
    // The View can read these properties to know how to draw itself.

    var tableCards: [SetCard] {
        model.tableCards
    }

    var selectedCardIDs: Set<UUID> {
        model.selectedCardIDs
    }

    var showSetSuccess: Bool {
        model.setFound
    }

    var showSetFail: Bool {
        model.setFail
    }

    var isDeckEmpty: Bool {
        model.deck.isEmpty
    }

    // MARK: - User Intents

    // Creates a new model and starts the game.
    func startNewGame() {
        model = SetGameModel()
        model.generateDeck()
    }

    // Passes the user's choice to the model.
    func selectCard(_ card: SetCard) {
        model.toggleSelection(for: card)
    }

    // Tells the model to deal more cards.
    func dealThreeMore() {
        model.dealCards(for: 3)
    }

}

extension SetGameViewModel {
    func color(for cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
}
