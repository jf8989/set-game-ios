// View/Components/CardView.swift

import SwiftUI

struct CardView: View {
    let card: CardSet
    let isSelected: Bool
    let setEvalStatus: SetEvalStatus
    let namespace: Namespace.ID

    @EnvironmentObject var viewModel: SetGameViewModel

    // This logic stays here, as it's specific to the card's state.
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
            // Guard against non-finite or zero height during layout/animation phases.
            let safeH: CGFloat =
                (geo.size.height.isFinite && geo.size.height > 0)
                ? geo.size.height : 1

            // This VStack is the "content" that my modifier will wrap.
            VStack(spacing: safeH * 0.05) {
                ForEach(0..<card.number.rawValue, id: \.self) { _ in
                    SetSymbolView(
                        symbol: card.symbol,
                        color: viewModel.color(for: card.color),
                        shading: card.shading
                    )
                    .frame(height: safeH * 0.27)
                }
            }
            // I'm applying my new custom modifier here.
            // This single line replaces the ZStack, fill, and stroke logic.
            .cardStyle(borderColor: borderColor, isSelected: isSelected)
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .matchedGeometryEffect(id: card.id, in: namespace)
        .scaleEffect(isSelected && setEvalStatus == .found ? 1.15 : 1.0)
        .rotationEffect(
            .degrees(isSelected && setEvalStatus == .fail ? 4 : 0)
        )
    }
}
