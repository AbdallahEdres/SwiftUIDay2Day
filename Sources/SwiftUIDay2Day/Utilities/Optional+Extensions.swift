//
//  Optional+Extensions.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 17/10/2025.
//

import Foundation

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let collection):
            return collection.isEmpty
        }
    }
}
