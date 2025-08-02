// View/SetSymbolView.swift

import SwiftUI

struct SetSymbolView: View {
    let symbol: CardSymbol
    let color: Color
    let shading: CardShading

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let width = size
            let height = size * 0.6

            switch symbol {
            case .diamond:
                symbolBody(shape: Diamond(), width: width, height: height)
            case .oval:
                symbolBody(shape: Capsule(), width: width, height: height)
            case .squiggle:
                symbolBody(shape: RoundedRectangle(cornerRadius: 18), width: width, height: height)
            }
        }
    }

    @ViewBuilder
    private func symbolBody<S: Shape>(shape: S, width: CGFloat, height: CGFloat) -> some View {
        switch shading {
        case .solid:
            shape
                .fill(color)
                .frame(width: width, height: height)
        case .open:
            shape
                .stroke(color, lineWidth: 2)
                .frame(width: width, height: height)
        case .striped:
            shape
                .fill(color.opacity(0.25))
                .frame(width: width, height: height)
        }
    }
}
