//
//  TextStyles.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 03/10/2025.
//

import SwiftUI

public enum AppTextStyle {
    case titleLarge
    case titleMedium
    case bodyBold
    case bodyRegular
    case caption
    case custom(size: CGFloat, font: AppFontWeight = .regular)
    
    public var font: Font {
        switch self {
        case .titleLarge:
            return .system(size: 24, weight: .bold)
        case .titleMedium:
            return .system(size: 16, weight: .bold)
        case .bodyBold:
            return .system(size: 14, weight: .bold)
        case .bodyRegular:
            return .system(size: 14, weight: .regular)
        case .caption:
            return .system(size: 12, weight: .regular)
        case .custom(let size, let fontWeight):
            return .system(size: size, weight: fontWeight.systemWeight)
        }
    }
}

public enum AppFontWeight {
    case black, bold, medium, regular, light
    
    var systemWeight: Font.Weight {
        switch self {
        case .black: return .black
        case .bold: return .bold
        case .medium: return .medium
        case .regular: return .regular
        case .light: return .light
        }
    }
}

public struct AppTextModifier: ViewModifier {
    let style: AppTextStyle
    let color: Color
    
    public init(style: AppTextStyle, color: Color = .primary) {
        self.style = style
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(color)
    }
}

public extension View {
    func appText(_ style: AppTextStyle, color: Color = .primary) -> some View {
        self.modifier(AppTextModifier(style: style, color: color))
    }
}
