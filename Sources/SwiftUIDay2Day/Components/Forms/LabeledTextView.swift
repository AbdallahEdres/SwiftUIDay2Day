//
//  LabeledTextView.swift
//  BaseSwiftUI
//
//  Created by Abdallah Edres on 23/10/2025.
//

import SwiftUI

struct LabeledTextView: View {
    
    // MARK: - Bindings
    @Binding var text: String?
    @Binding var errorMessage: String?
    
    // MARK: - Focus
    @State private var isFocused: Bool = false
    
    // MARK: - Configuration
    var placeHolder: String
    var label: String
    var isRequired: Bool = true
    var image: Image? 
    var trailingImage: Image? = nil
    var fieldBackgroundColor: Color = Color.white
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            labelView
            textView
            if let errorMessage, !errorMessage.isEmpty {
                errorView
            }
        }
    }
}

// MARK: - Subviews
private extension LabeledTextView {
    
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
    
    // MARK: textView
    var textView: some View {
        HStack(alignment: .center, spacing: 8) {
            // Leading Icon
            if let image {
                image
                    .renderingMode(.template)
                    .foregroundStyle(text.isNilOrEmpty ? Color.gray : Color.main)
                    .frame(width: 24, height: 24)
            }
            
            // Input Field
            TextView(text: $text, isEditable: true, isFocused: $isFocused)
                .frame(minHeight: 48, maxHeight: .infinity, alignment: .center)
                .overlay(alignment: .leading) {
                    if !isFocused && text.isNilOrEmpty {
                        Text(placeHolder)
                            .appText(.bodyRegular, color: .appPlaceHolder)
                            .padding(.leading, 5)
                    }

                }
            // Trailing Icon
            if let trailingImage {
                trailingImage
                    .renderingMode(.template)
                    .foregroundStyle(text.isNilOrEmpty ? Color.gray : Color.main)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 12)
//        .frame(minHeight: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(fieldBackgroundColor)
        )
        .overlay(
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        (
                            isFocused || !text.isNilOrEmpty
                        ) ? Color.main : Color.appPlaceHolder,
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
