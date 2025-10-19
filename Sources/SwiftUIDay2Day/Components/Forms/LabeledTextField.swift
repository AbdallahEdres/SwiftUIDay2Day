//
//  LabeledTextField.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 03/09/2025.
//

import SwiftUI

public struct LabeledTextField: View {
    
    @Binding private var text: String
    @Binding private var errorMessage: String?
    @FocusState private var isFocused: Bool
    
    private let placeHolder: String
    private let label: String
    private let isRequired: Bool
    private let image: Image?
    private let trailingImage: Image?
    
    public init(
        text: Binding<String>,
        errorMessage: Binding<String?> = .constant(nil),
        placeHolder: String,
        label: String,
        isRequired: Bool = true,
        image: Image? = nil,
        trailingImage: Image? = nil
    ) {
        self._text = text
        self._errorMessage = errorMessage
        self.placeHolder = placeHolder
        self.label = label
        self.isRequired = isRequired
        self.image = image
        self.trailingImage = trailingImage
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            labelView
            textField
            if let errorMessage, !errorMessage.isEmpty {
                errorView
            }
        }
    }
    
    private var labelView: some View {
        HStack(spacing: 4) {
            Text(label)
                .appText(.bodyRegular)
            
            if !isRequired {
                Text("(Optional)")
                    .appText(.caption, color: .gray)
            }
        }
    }
    
    private var textField: some View {
        HStack(spacing: 8) {
            if let image {
                image
                    .renderingMode(.template)
                    .foregroundStyle(text.isEmpty ? .gray : .blue)
                    .frame(width: 24, height: 24)
            }
            
            TextField(placeHolder, text: $text)
                .appText(.bodyRegular)
                .focused($isFocused)
            
            if let trailingImage {
                trailingImage
                    .renderingMode(.template)
                    .foregroundStyle(text.isEmpty ? .gray : .blue)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    (isFocused || !text.isEmpty) ? .blue : .clear,
                    lineWidth: 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    private var errorView: some View {
        Text(errorMessage ?? "")
            .appText(.bodyRegular, color: .red)
    }
}

struct LabeledTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 20) {
                StatefulPreviewWrapper("John Doe", "Name is required") { text, error in
                    LabeledTextField(
                        text: text,
                        errorMessage: error,
                        placeHolder: "Enter your name",
                        label: "Full Name",
                        image: Image(systemName: "person.fill"),
                        trailingImage: Image(systemName: "checkmark.circle")
                    )
                }
                
                StatefulPreviewWrapper("", nil) { text, error in
                    LabeledTextField(
                        text: text,
                        errorMessage: error,
                        placeHolder: "Enter your email",
                        label: "Email",
                        image: Image(systemName: "envelope"),
                        trailingImage: nil
                    )
                }
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>, Binding<String?>) -> Content
    @State private var error: String? = nil
    
    init(_ value: Value, _ error: String?, @ViewBuilder content: @escaping (Binding<Value>, Binding<String?>) -> Content) {
        _value = State(initialValue: value)
        _error = State(initialValue: error)
        self.content = content
    }
    
    var body: some View {
        content($value, $error)
    }
}
