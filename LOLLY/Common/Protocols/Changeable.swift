//
//  Changeable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.10.2025.
//

public protocol Changeable {
    func changing(_ change: (inout Self) -> Void) -> Self
}

extension Changeable {
    public func changing(_ change: (inout Self) -> Void) -> Self {
        var value = self
        change(&value)
        return value
    }
}
