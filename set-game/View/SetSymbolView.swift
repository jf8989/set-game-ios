// View/SetSymbolView.swift

import SwiftUI

struct SetSymbolView: View {
    let symbol: CardSymbol  // type enum CardSymbol
    let color: Color
    let shading: CardShading

    private var shape: AnyView {
        switch symbol {
        case .diamond:
            return AnyView(Diamond())
        case .oval:
            return AnyView(Capsule())
        case .squiggle:
            return AnyView(RoundedRectangle(cornerRadius: 18))
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            switch shading {
            case .solid:
                shape
//                    .fill(color)
                    .frame(width: size, height: size * 0.4)
            case .open:
                shape
//                    .stroke(color, lineWidth: 2)
                    .frame(width: size, height: size * 0.4)
            case .striped:
                shape
//                    .fill(color.opacity(0.3))
                    .frame(width: size, height: size * 0.4)
            }
        }
    }

}
