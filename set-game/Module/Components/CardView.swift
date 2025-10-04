/// Path: set-game/Module/Components/CardView.swift
/// Role: Renders a single card; no dependency on the ViewModel

import SwiftUI

struct CardView: View {
    let card: CardSet
    let isSelected: Bool
    let setEvalStatus: SetEvalStatus
    let namespace: Namespace.ID

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

            VStack(spacing: safeH * SetGameTheme.symbolVerticalSpacingFactor) {
                ForEach(0..<card.number.rawValue, id: \.self) { _ in
                    SetSymbolView(
                        symbol: card.symbol,
                        color: card.color.uiColor,
                        shading: card.shading
                    )
                    .frame(height: safeH * SetGameTheme.symbolRowHeightFactor)
                }
            }
            .cardStyle(borderColor: borderColor, isSelected: isSelected)
        }
        .aspectRatio(SetGameTheme.cardAspectRatio, contentMode: .fit)
        .matchedGeometryEffect(id: card.id, in: namespace)
        .scaleEffect(isSelected && setEvalStatus == .found ? SetGameTheme.setFoundScale : 1.0)
        .rotationEffect(.degrees(isSelected && setEvalStatus == .fail ? SetGameTheme.setFailRotationDegrees : 0))
    }
}
