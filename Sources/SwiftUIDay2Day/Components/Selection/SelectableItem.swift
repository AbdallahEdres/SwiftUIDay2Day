//
//  SelectableItem.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 08/09/2025.
//

import Foundation

public protocol SelectableItem: Identifiable, Equatable {
    var title: String { get }
    var isSelected: Bool { get set }
    var image: String? { get }
}
