//
//  CardModifiers.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 05/10/2025.
//

import SwiftUI

public struct WhiteCardBackground: ViewModifier {
    var cornerRadius: CGFloat = 12
    
    public func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

public struct OutlineCard: ViewModifier {
    var cornerRadius: CGFloat = 12
    var lineWidth: CGFloat = 1
    var borderColor: Color = .gray.opacity(0.3)
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

public struct DashedCard: ViewModifier {
    var cornerRadius: CGFloat = 12
    var lineWidth: CGFloat = 2
    var dash: [CGFloat] = [5]
    var borderColor: Color = .gray.opacity(0.5)

    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
                    .foregroundColor(borderColor)
            )
    }
}

public extension View {
    func whiteCardBackground(cornerRadius: CGFloat = 12) -> some View {
        self.modifier(WhiteCardBackground(cornerRadius: cornerRadius))
    }
    
    func outlineCard(cornerRadius: CGFloat = 12, lineWidth: CGFloat = 1, borderColor: Color = .gray.opacity(0.3)) -> some View {
        self.modifier(OutlineCard(cornerRadius: cornerRadius, lineWidth: lineWidth, borderColor: borderColor))
    }
    
    func dashedCard(cornerRadius: CGFloat = 12, lineWidth: CGFloat = 2, dash: [CGFloat] = [5], borderColor: Color = .gray.opacity(0.5)) -> some View {
        self.modifier(DashedCard(cornerRadius: cornerRadius, lineWidth: lineWidth, dash: dash, borderColor: borderColor))
    }
}

struct CardModifiers_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            
            // White Card
            Text("White Card Background")
                .padding()
                .whiteCardBackground()
            
            // Outline Card
            Text("Outline Card")
                .padding()
                .outlineCard(cornerRadius: 16, lineWidth: 2, borderColor: .blue)
            
            // Dashed Card
            Text("Dashed Card")
                .padding()
                .dashedCard(cornerRadius: 16, lineWidth: 2, dash: [8,4], borderColor: .red)
            
            // Combination Example
            Text("White + Outline")
                .padding()
                .whiteCardBackground()
                .outlineCard(lineWidth: 1, borderColor: .green)
            
            Text("White + Dashed")
                .padding()
                .whiteCardBackground()
                .dashedCard(lineWidth: 2, dash: [6,3], borderColor: .purple)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
