//
//  LabeledTextField.swift
//  SwiftUiBase
//
//  Created by Abdallah Edres on 03/09/2025.
//

import SwiftUI

struct LabeledTextField: View {
    
    // MARK: - Bindings
    @Binding var text: String
    @Binding var errorMessage: String?
    
    // MARK: - Focus
    @FocusState private var isFocused: Bool
    
    // MARK: - Configuration
    var placeHolder: String
    var label: String
    var isRequired: Bool = true
    var image: Image?
    var trailingImage: Image? = nil
    var keyboardType: UIKeyboardType = .default
    var fieldBackgroundColor: Color = Color.white
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            labelView
            textField
            if let errorMessage, !errorMessage.isEmpty {
                errorView
            }
        }
    }
}

// MARK: - Subviews
private extension LabeledTextField {
    
    // MARK: Label
    var labelView: some View {
        HStack(spacing: 4) {
            Text(label)
                .appText(.bodyRegular)
            
            if !isRequired {
                Text("optional_label".baseLocalizable)
                    .appText(.caption, color: .appPlaceHolder)
            }
        }
    }
    
    // MARK: TextField
    var textField: some View {
        HStack(spacing: 8) {
            // Leading Icon
            if let image {
                image
                    .renderingMode(.template)
                    .foregroundStyle(text.isEmpty ? Color.gray : Color.main)
                    .frame(width: 24, height: 24)
            }
            
            // Input Field
            TextField(placeHolder, text: $text)
                .appText(.bodyRegular)
                .focused($isFocused)
                .keyboardType(keyboardType)
            
            // Trailing Icon
            if let trailingImage {
                trailingImage
                    .renderingMode(.template)
                    .foregroundStyle(text.isEmpty ? Color.gray : Color.main)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(fieldBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    (isFocused || !text.isEmpty) ? Color.main : Color.appPlaceHolder,
                    lineWidth: 1
                )
                .padding(0.5)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    // MARK: Error Label
    var errorView: some View {
        Text(errorMessage ?? "")
            .appText(.bodyRegular, color: .red)
    }
}
