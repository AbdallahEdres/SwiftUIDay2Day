//
//  OTPView.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 11/09/2025.
//

import SwiftUI

public struct OTPView: View {
    
    @Binding var code: String
    private let digits: Int
    private let onCommit: (() -> Void)?
    
    @State private var innerText: String = ""
    @FocusState private var isFocused: Bool
    
    public init(
        code: Binding<String>,
        digits: Int = 4,
        onCommit: (() -> Void)? = nil
    ) {
        self._code = code
        self.digits = digits
        self.onCommit = onCommit
    }
    
    public var body: some View {
        ZStack {
            TextField("", text: $innerText)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .accentColor(.clear)
                .foregroundColor(.clear)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .onAppear {
                    innerText = code
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.isFocused = true
                    }
                }
                .onChange(of: innerText, perform: onInnerTextChange)
                .onChange(of: code) { newCode in
                    if newCode != innerText {
                        innerText = newCode
                    }
                }
                .accessibilityHidden(true)
                .frame(width: 0, height: 0)
            
            HStack(spacing: 12) {
                ForEach(0..<digits, id: \.self) { idx in
                    otpBox(at: idx)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
            .environment(\.layoutDirection, .leftToRight)
        }
    }
    
    private func onInnerTextChange(_ newValue: String) {
        let filtered = newValue.filter { $0.isWholeNumber }
        let limited = String(filtered.prefix(digits))
        
        if limited != innerText {
            innerText = limited
        }
        if code != limited {
            code = limited
        }
        
        if limited.count == digits {
            isFocused = false
            onCommit?()
        }
    }
    
    @ViewBuilder
    private func otpBox(at index: Int) -> some View {
        let char: String = {
            if index < innerText.count {
                let strIdx = innerText.index(innerText.startIndex, offsetBy: index)
                return String(innerText[strIdx])
            } else {
                return ""
            }
        }()
        
        ZStack {
            Circle()
                .strokeBorder(lineWidth: 1)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                )
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
            
            if !char.isEmpty {
                Text(char)
                    .font(.title2.monospacedDigit())
                    .bold()
            } else if isFocused && index == innerText.count {
                blinkingCursor()
            }
        }
        .animation(.easeInOut(duration: 0.12), value: innerText)
        .accessibilityLabel("Digit \(index + 1)")
    }
    
    private func blinkingCursor() -> some View {
        Rectangle()
            .frame(width: 2, height: 24)
            .cornerRadius(1)
            .opacity(0.9)
            .transition(.opacity)
            .modifier(BlinkAnimation())
    }
}

struct BlinkAnimation: ViewModifier {
    @State private var visible: Bool = true
    
    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0.1)
            .onAppear {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: true)) {
                    visible.toggle()
                }
            }
    }
}

struct OTPView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var code: String = ""
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Enter OTP:")
                    .font(.headline)
                
                OTPView(code: $code, digits: 4) {
                    print("OTP Completed: \(code)")
                }
                
                Text("Current code: \(code)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
    }
}
