//
//  ButtonExtensions.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 03/10/2025.
//

import SwiftUI

public extension Button {
    func mainButton(
        height: CGFloat = 48,
        isActive: Bool = true,
        fontStyle: AppTextStyle = .titleMedium
    ) -> some View {
        self.buttonStyle(MainButtonStyle(
            height: height,
            fontStyle: fontStyle,
            isActive: isActive
        ))
    }
    
    func outlinedButton(
        height: CGFloat = 48,
        isActive: Bool = true,
        fontStyle: AppTextStyle = .titleMedium
    ) -> some View {
        self.buttonStyle(OutlinedButtonStyle(
            height: height,
            fontStyle: fontStyle,
            isActive: isActive
        ))
    }
    
    func underlinedTextButton(
        isActive: Bool = true,
        fontStyle: AppTextStyle = .titleMedium
    ) -> some View {
        self.buttonStyle(UnderlinedTextButtonStyle(
            fontStyle: fontStyle,
            isActive: isActive
        ))
    }
}
