// ViewModel/SetGameViewModel.swift

import Foundation

class SetGameViewModel: ObservableObject {
    @Published var tableCards: [SetCard] = []

    private var model = SetGameModel()

    func startNewGame() {
        model.generateDeck() // Generate the deck and deal 12 cards
        tableCards = model.tableCards  // Fetch the model's table cards
    }
    
    // Handle selection
    func selectCard(_ card: SetCard) {
        model.toggleSelection(for: card)  // Handles card selection logic
        tableCards = model.tableCards // Updates the tablecard's current state
    }
}
