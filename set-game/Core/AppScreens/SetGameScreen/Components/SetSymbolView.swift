/// Path: Core/AppScreens/SetGameScreen/Components/SetSymbolView.swift
/// Role: Draw one symbol using our custom shapes (Diamond/Oval/Squiggle)

import SwiftUI

/// Draws ONE symbol (diamond / oval / squiggle) in the requested color & shading.
/// CardView stacks 1-3 of these vertically.
struct SetSymbolView: View {
    let symbol: CardSymbol
    let color: Color
    let shading: CardShading

    var body: some View {
        GeometryReader { geo in
            // Symbol size: 70 % of card width, 60 % of that for height.
            let width = geo.size.width * SetGameTheme.symbolWidthFactor
            let height = width * SetGameTheme.symbolHeightFactor

            switch symbol {
            case .diamond:
                symbolBody(shape: Diamond(), width: width, height: height)
            case .oval:
                symbolBody(shape: Oval(), width: width, height: height)
            case .squiggle:
                symbolBody(shape: Squiggle(), width: width, height: height)
            }
        }
    }

    /// Applies solid / open / striped rendering + centres the shape.
    @ViewBuilder
    private func symbolBody<shape: Shape>(
        shape: shape,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        switch shading {

        case .solid:
            shape
                .fill(color)
                .frame(width: width, height: height)
                .centerInParent()

        case .open:
            shape
                .stroke(color, lineWidth: 2)
                .frame(width: width, height: height)
                .centerInParent()

        case .striped:
            shape
                .fill(color.opacity(SetGameTheme.stripedFillOpacity))
                .frame(width: width, height: height)
                .centerInParent()
        }
    }
}

/// REUSABLE modifier for centring in GeometryReader space.
extension View {
    fileprivate func centerInParent() -> some View {
        self.frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
    }
}
