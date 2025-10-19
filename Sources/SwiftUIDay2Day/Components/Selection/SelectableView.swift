//
//  SelectableView.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 09/09/2025.
//

import SwiftUI

public struct SelectableView<T: SelectableItem>: View {
    @Binding var item: T
    
    public init(item: Binding<T>) {
        self._item = item
    }
    
    public var body: some View {
        HStack {
            if let imageName = item.image {
                Text(imageName)
                    .frame(width: 30, height: 20)
            }

            Text(item.title)
            Spacer()
            Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isSelected ? .blue : .gray)
        }
        .appText(.bodyRegular, color: .primary)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}
