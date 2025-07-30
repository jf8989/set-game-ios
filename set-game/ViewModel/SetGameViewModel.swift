// ViewModel/SetGameViewModel.swift

import Foundation

class SetGameViewModel: ObservableObject {
    @Published var deck: [SetCard] = []
    @Published var selectedCards: [SetCard] = []
    
    private var model = SetGameModel()
    
}
