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
    
    // MARK: - Configuration
    private let isEditable: Bool
    private let font: UIFont?
    private let textColor: Color
    
    // MARK: - Initializers
    
    /// Initialize with plain text binding
    init(
        text: Binding<String?>,
        isEditable: Bool = true,
        font: UIFont? = nil,
        textColor: Color = .black
    ) {
        _text = text
        self._attributedText = .constant(nil)
        self.isEditable = isEditable
        self.font = font
        self.textColor = textColor
    }
    
    /// Initialize with attributed text binding
    init(
        attributedText: Binding<NSAttributedString?>,
        isEditable: Bool = true,
        font: UIFont? = nil,
        textColor: Color = .black
    ) {
        _text = .constant(nil)
        self._attributedText = attributedText
        self.isEditable = isEditable
        self.font = font
        self.textColor = textColor
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UITextView {
        // Use self-sizing subclass to enable automatic height adjustment
        let textView = SelfSizingTextView()
        
        // Assign text or attributed text if available
        if let _ = self.text {
            textView.text = self.text
        } else if let _ = self.attributedText {
            textView.attributedText = self.attributedText
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
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Sync text binding and trigger layout update
            parent.text = textView.text
            textView.invalidateIntrinsicContentSize()
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
