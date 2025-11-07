//
//  Optional+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

extension Optional where Wrapped: Collection {
    /// SwifterSwift: Check if optional is nil or empty collection.
    public var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }

    /// SwifterSwift: Returns the collection only if it is not nill and not empty.
    public var nonEmpty: Wrapped? {
        guard let collection = self else { return nil }
        guard !collection.isEmpty else { return nil }
        return collection
    }
}
