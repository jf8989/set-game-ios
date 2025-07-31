// View/Shapes/Diamond.swift

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // top midpoint
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // line to right midpoint
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        // line to bottom midpoint
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        // line to left midpoint
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        // close the path
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    Diamond().stroke(.red, lineWidth: 3).frame(width: 60, height: 100)
}
