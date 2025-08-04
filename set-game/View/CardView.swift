// View/CardView.swift

import SwiftUI

struct CardView: View {
    let card: SetCard
    let isSelected: Bool
    let setEvalStatus: SetEvalStatus
    let namespace: Namespace.ID  // animation

    @EnvironmentObject var viewModel: SetGameViewModel

    // Border colour based on selection state
    private var borderColor: Color {
        guard isSelected else { return .primary }
        switch setEvalStatus {
        case .found: return .green
        case .fail: return .red
        case .none: return .blue
        }
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
