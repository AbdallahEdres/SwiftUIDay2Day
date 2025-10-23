//
//  TextView.swift
//  BaseSwiftUI
//
//  Created by Abdallah Edres on 22/10/2025.
//

import SwiftUI

// MARK: - TextView (UIViewRepresentable)
// A SwiftUI wrapper around UITextView that supports both plain and attributed text,
// with automatic height adjustment based on content.
struct TextView: UIViewRepresentable {
    
    // MARK: - Bindings
    @Binding var text: String?
    @Binding var attributedText: NSAttributedString?
    @Binding var isFocused: Bool
    
    // MARK: - Configuration
    private let isEditable: Bool
    private let font: UIFont?
    private let textColor: Color
    
    // MARK: - Initializers
    
    /// Initialize with plain text binding
    init(
        text: Binding<String?>,
        isEditable: Bool = true,
        font: UIFont? = UIFont(name: AppFontWeight.regularAppFont.rawValue, size: 14),
        textColor: Color = .black,
        isFocused: Binding<Bool> = .constant(false)
    ) {
        _text = text
        self._attributedText = .constant(nil)
        self.isEditable = isEditable
        self.font = font
        self.textColor = textColor
        self._isFocused = isFocused
    }
    
    /// Initialize with attributed text binding
    init(
        attributedText: Binding<NSAttributedString?>,
        isEditable: Bool = true,
        font: UIFont? = UIFont(name: AppFontWeight.regularAppFont.rawValue, size: 14),
        textColor: Color = .black,
        isFocused: Binding<Bool> = .constant(false)
    ) {
        _text = .constant(nil)
        self._attributedText = attributedText
        self.isEditable = isEditable
        self.font = font
        self.textColor = textColor
        self._isFocused = isFocused
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UITextView {
        // Use self-sizing subclass to enable automatic height adjustment
        let textView = SelfSizingTextView()
        textView.delegate = context.coordinator
        
        // Assign text or attributed text if available
        if let text = self.text {
            textView.text = text
        } else if let attributedText = self.attributedText {
            textView.attributedText = attributedText
        }
        
        // Apply appearance
        if let font = self.font {
            textView.font = font
        }
        
        textView.textColor = UIColor(self.textColor)
        textView.backgroundColor = .clear
        textView.isEditable = isEditable
        textView.dataDetectorTypes = [.all]
        textView.isScrollEnabled = false
        
        // Allow the view to expand vertically in SwiftUI layouts
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.inputAccessoryView = makeKeyboardToolbar(target: context.coordinator)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update plain text if needed
        if let text = self.text, text != uiView.text {
            uiView.text = text
            
            // Update attributed text if provided
        } else if let attributed = self.attributedText, attributed != uiView.attributedText {
            let mutable = NSMutableAttributedString(attributedString: attributed)
            let fullRange = NSRange(location: 0, length: mutable.length)
            
            // Apply custom font if set
            if let font = self.font {
                mutable.addAttribute(.font, value: font, range: fullRange)
            }
            
            // Apply custom text color
            let uiColor = UIColor(self.textColor)
            mutable.addAttribute(.foregroundColor, value: uiColor, range: fullRange)
            uiView.attributedText = mutable
        }
        
        // Handle focus changes from SwiftUI
        let isCurrentlyFirstResponder = uiView.isFirstResponder
        if isFocused && !isCurrentlyFirstResponder {
            context.coordinator.isProgrammaticChange = true
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
                context.coordinator.isProgrammaticChange = false
            }
        } else if !isFocused && isCurrentlyFirstResponder {
            context.coordinator.isProgrammaticChange = true
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
                context.coordinator.isProgrammaticChange = false
            }
        }
    }
    
    // MARK: - Keyboard Toolbar
    private func makeKeyboardToolbar(target: Any?) -> UIView {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(
            title: "keyboard_done".baseLocalizable,
            style: .done,
            target: target,
            action: #selector(Coordinator.dismissKeyboard)
        )
        
        toolbar.items = [flexible, done]
        return toolbar
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        var isProgrammaticChange = false
        
        init(parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Sync text binding and trigger layout update
            parent.text = textView.text
            textView.invalidateIntrinsicContentSize()
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            guard !isProgrammaticChange else { return }
            DispatchQueue.main.async { [weak self] in
                self?.parent.isFocused = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.trimWhiteSpace().isEmpty{
                textView.text = ""
                parent.text = ""
            }
            guard !isProgrammaticChange else { return }
            DispatchQueue.main.async { [weak self] in
                self?.parent.isFocused = false
            }
            
        }
        
        @objc func dismissKeyboard() {
            parent.isFocused = false
        }
    }
}

// MARK: - SelfSizingTextView
// Custom UITextView subclass that automatically resizes based on its content.
private final class SelfSizingTextView: UITextView {
    override var intrinsicContentSize: CGSize {
        // Calculate the height based on text content
        let size = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        let newSize = sizeThatFits(size)
        return CGSize(width: UIView.noIntrinsicMetric, height: newSize.height)
    }
}
