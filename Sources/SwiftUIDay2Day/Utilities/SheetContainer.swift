//
//  SheetContainer.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 09/09/2025.
//

import SwiftUI

public struct SheetContainer<Content: View>: View {
    var content: () -> Content
    @Environment(\.dismiss) var dismiss

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Button("Done") {
                       dismiss()
                    }
                    .appText(.bodyBold, color: .blue)
                }
                
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
            .padding()
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
