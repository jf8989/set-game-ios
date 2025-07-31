// View/SetGameView.swift

import SwiftUI
import UIKit

struct SetGameView: View {
    @StateObject private var viewModel = SetGameViewModel()

    var body: some View {
        VStack {
            Text("Set Game")
                .font(.largeTitle)
                .padding(.top)

            ScrollView {
                let columns = [
                    GridItem(.adaptive(minimum: 70), spacing: 12)
                ]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.tableCards) { card in
                        CardView(
                            card: card,
                            isSelected: viewModel.selectedCardIDs.contains(
                                card.id
                            )
                        )
                        .aspectRatio(2 / 3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.selectCard(card)
                        }
                        .padding(4)
                    }
                }
            }
            .padding(4)
        }
        .onAppear {
            viewModel.startNewGame()
        }
        Spacer()

        // Space for buttons
    }
}

struct CardView: View {
    let card: SetCard
    let isSelected: Bool

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    isSelected
                        ? Color.blue.opacity(0.3) : Color(.systemBackground)
                )

            // Card border
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(
                    isSelected ? Color.blue : Color.primary,
                    lineWidth: 3
                )

            // Card symbol
            Text("\(card.symbol.rawValue)")
                .font(.title)
                .foregroundColor(.primary)
        }
        .aspectRatio(2 / 3, contentMode: .fill)
        .padding(2)
    }

}

#Preview {
    SetGameView()
}
