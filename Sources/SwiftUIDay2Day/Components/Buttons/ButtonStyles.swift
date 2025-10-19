//
//  ButtonStyles.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 03/10/2025.
//

import SwiftUI

public struct MainButtonStyle: ButtonStyle {
    private let height: CGFloat
    private let fontStyle: AppTextStyle
    private let isActive: Bool
    private let color: Color
    
    public init(
        height: CGFloat = 48,
        fontStyle: AppTextStyle = .titleMedium,
        isActive: Bool = true,
        color: Color = .blue
    ) {
        self.height = height
        self.fontStyle = fontStyle
        self.isActive = isActive
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(fontStyle.font)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isActive ? color : Color.gray.opacity(0.5))
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

public struct OutlinedButtonStyle: ButtonStyle {
    private let height: CGFloat
    private let fontStyle: AppTextStyle
    private let isActive: Bool
    private let color: Color
    
    public init(
        height: CGFloat = 48,
        fontStyle: AppTextStyle = .titleMedium,
        isActive: Bool = true,
        color: Color = .blue
    ) {
        self.height = height
        self.fontStyle = fontStyle
        self.isActive = isActive
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isActive ? color : .gray)
            .font(fontStyle.font)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? color : .gray, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

public struct UnderlinedTextButtonStyle: ButtonStyle {
    private let fontStyle: AppTextStyle
    private let isActive: Bool
    private let color: Color
    
    public init(
        fontStyle: AppTextStyle = .titleMedium,
        isActive: Bool = true,
        color: Color = .blue
    ) {
        self.fontStyle = fontStyle
        self.isActive = isActive
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(fontStyle.font)
            .foregroundColor(isActive ? color : .gray)
            .underline()
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .frame(height: 48)
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Main Button
            Button("Main Button") {}
                .buttonStyle(MainButtonStyle())
            
            // Disabled Main Button
            Button("Disabled Main") {}
                .buttonStyle(MainButtonStyle(isActive: false))
            
            // Outlined Button
            Button("Outlined Button") {}
                .buttonStyle(OutlinedButtonStyle())
            
            // Disabled Outlined Button
            Button("Disabled Outlined") {}
                .buttonStyle(OutlinedButtonStyle(isActive: false))
            
            // Underlined Text Button
            Button("Underlined Button") {}
                .buttonStyle(UnderlinedTextButtonStyle())
            
            // Disabled Underlined Button
            Button("Disabled Underlined") {}
                .buttonStyle(UnderlinedTextButtonStyle(isActive: false))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
