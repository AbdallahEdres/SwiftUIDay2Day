//
//  SingleSelectableView.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 09/09/2025.
//

import SwiftUI

public struct SingleSelectableView<T: SelectableItem>: View {
    
    @Binding public var items: [T]
    @Binding public var selectedItem: T?
    @State private var searchText: String = ""
    
    public init(items: Binding<[T]>, selectedItem: Binding<T?>) {
        self._items = items
        self._selectedItem = selectedItem
    }
    
    private var filteredItems: [T] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func rowBackGround(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(isSelected ? .blue : .clear)
            }
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .appText(.bodyRegular)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredItems, id: \.id) { item in
                        SelectableView(item: binding(for: item))
                            .background(rowBackGround(isSelected: item.isSelected))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                selectItem(item)
                            }
                    }
                }
            }
        }
    }
    
    func selectItem(_ item: T) {
        for i in items.indices {
            items[i].isSelected = false
        }
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isSelected.toggle()
        }
        selectedItem = items.first(where: { $0.isSelected })
    }
    
    func binding(for item: T) -> Binding<T> {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Item not found")
        }
        return $items[index]
    }
}

struct DemoItem: SelectableItem, Identifiable {
    var id: Int?
    var title: String
    var isSelected: Bool = false
    var image: String? = nil
}

struct SingleSelectableView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var items: [DemoItem] = [
            DemoItem(id: 1, title: "Item 1"),
            DemoItem(id: 2, title: "Item 2"),
            DemoItem(id: 3, title: "Item 3"),
            DemoItem(id: 4, title: "Item 4")
        ]
        @State private var selectedItem: DemoItem? = nil
        
        var body: some View {
            VStack(spacing: 16) {
                SingleSelectableView(items: $items, selectedItem: $selectedItem)
                    .frame(height: 300)
                
                if let selectedItem {
                    Text("Selected: \(selectedItem.title)")
                        .font(.headline)
                        .foregroundColor(.blue)
                } else {
                    Text("No item selected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
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
