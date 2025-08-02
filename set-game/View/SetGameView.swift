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
                                card.id,
                            ),
                            showSetSuccess: viewModel.showSetSuccess,
                            showSetFail: viewModel.showSetFail
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
    let showSetSuccess: Bool
    let showSetFail: Bool

    @EnvironmentObject var viewModel: SetGameViewModel

    // Selects color for the card's border upon selection
    private var selectionColor: Color {
        if isSelected {
            if showSetSuccess {
                return .green  // for a Set!
            } else if showSetFail {
                return .red  // for a missmatch
            } else {
                return .blue  // it's a pending selection
            }
        } else {
            return .primary  // no selection made yet
        }
    }

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 18)

            // Card background
            shape.fill(Color(.systemBackground))

            // Card border
            shape.strokeBorder(selectionColor, lineWidth: isSelected ? 4 : 2)

            // Card symbol
            GeometryReader { geo in
                VStack(spacing: geo.size.height * 0.08) {
                    ForEach(0..<card.number.rawValue, id: \.self) { _ in
                        SetSymbolView(
                            symbol: card.symbol,
                            color: viewModel.color(for: card.color),
                            shading: card.shading
                        )
                        .frame(
                            width: geo.size.width * 0.6,
                            height: geo.size.height * 0.18
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(10)
        }
        .aspectRatio(2 / 3, contentMode: .fill)
        .padding(2)
    }

}

#Preview {
    SetGameView().environmentObject(SetGameViewModel())
}
