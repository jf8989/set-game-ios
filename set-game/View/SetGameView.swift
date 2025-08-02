// View/SetGameView.swift

import SwiftUI

// MARK: - Top-level screen

struct SetGameView: View {
    @StateObject private var viewModel = SetGameViewModel()
    @Namespace private var dealSpace

    var body: some View {
        VStack {
            // Title
            Text("Set Game")
                .font(.largeTitle)
                .padding(.top)

            // Card grid
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 70))],
                    spacing: 12
                ) {
                    ForEach(viewModel.tableCards) { card in
                        CardView(
                            card: card,
                            isSelected: viewModel.selectedCardIDs.contains(
                                card.id
                            ),
                            showSetSuccess: viewModel.showSetSuccess,
                            showSetFail: viewModel.showSetFail,
                            namespace: dealSpace  // ★
                        )
                        .aspectRatio(2 / 3, contentMode: .fit)
                        .onTapGesture { viewModel.selectCard(card) }
                        // fade in-out animation
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.8)
                                    .combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                // animates any change of the tableCards array
                .animation(
                    .spring(response: 0.35, dampingFraction: 0.75),
                    value: viewModel.tableCards
                )
                .environmentObject(viewModel)  // one injection for all
            }

            Spacer()

            // Control buttons
            HStack {
                Button("New Game") {
                    withAnimation { viewModel.startNewGame() }
                }
                Spacer()
                Button("Deal 3 More") {
                    withAnimation { viewModel.dealThreeMore() }
                }
                .disabled(viewModel.isDeckEmpty)
            }
            .font(.title2)
            .padding()
        }
    }
}

// MARK: - Single playing card

struct CardView: View {
    let card: SetCard
    let isSelected: Bool
    let showSetSuccess: Bool
    let showSetFail: Bool
    let namespace: Namespace.ID  // animation

    @EnvironmentObject var viewModel: SetGameViewModel

    // Border colour based on selection state
    private var borderColor: Color {
        if isSelected {
            if showSetSuccess { return .green }
            if showSetFail { return .red }
            return .blue
        }
        return .primary
    }

    var body: some View {
        GeometryReader { geo in
            let rect = RoundedRectangle(cornerRadius: 18)

            ZStack {
                rect.fill(Color(.systemBackground))
                rect.stroke(borderColor, lineWidth: isSelected ? 4 : 2)

                // Symbol stack (1‒3) – centred
                VStack(spacing: geo.size.height * 0.05) {
                    ForEach(0..<card.number.rawValue, id: \.self) { _ in
                        SetSymbolView(
                            symbol: card.symbol,
                            color: viewModel.color(for: card.color),
                            shading: card.shading
                        )
                        .frame(height: geo.size.height * 0.27)
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
            }
            .matchedGeometryEffect(id: card.id, in: namespace)  // smooth move
        }
        .aspectRatio(2 / 3, contentMode: .fit)
    }
}

// MARK: - Preview

#Preview {
    SetGameView()
        .environmentObject(SetGameViewModel())
}
