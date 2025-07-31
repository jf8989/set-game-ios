// View/SetGameView.swift

import SwiftUI

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
                        CardView(card: card)
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

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(lineWidth: 2)
                .foregroundColor(.gray)
            Text("\(card.symbol.hashValue)")  // placeholder
                .font(.title)
        }
        .background(Color.white)
        .aspectRatio(2 / 3, contentMode: .fit)
    }
}

#Preview {
    SetGameView()
}
