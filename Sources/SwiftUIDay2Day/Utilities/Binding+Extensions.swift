//
//  Binding+Extensions.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 17/10/2025.
//

import SwiftUI

public extension Binding where Value: ExpressibleByNilLiteral {
    func unwrapped<T>(default defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { newValue in
                if let str = newValue as? String {
                    self.wrappedValue = str.isEmpty ? nil : newValue
                } else {
                    self.wrappedValue = newValue
                }
            }
        )
    }
}
