// ViewModel/SetGameViewModel.swift

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var tableCards: [SetCard] = []
    @Published var selectedCardIDs: Set<UUID> = []
    @Published var showSetFail: Bool = false

    private var model = SetGameModel()

    func startNewGame() {
        model.generateDeck()  // Generate the deck and deal 12 cards
        tableCards = model.tableCards  // Fetch the model's table cards
        selectedCardIDs = model.selectedCardIDs  // reset when new game
        showSetFail = model.showSetFail
    }

    // Handle selection
    func selectCard(_ card: SetCard) {
        model.toggleSelection(for: card)  // Handles card selection logic
        tableCards = model.tableCards  // Updates the tablecard's current state
        selectedCardIDs = model.selectedCardIDs  // sync selected cards after selection changes
        showSetFail = model.showSetFail
    }
}
