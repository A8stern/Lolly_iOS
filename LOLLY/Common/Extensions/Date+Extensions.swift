//
//  Date+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

import Foundation

// MARK: - Date

public extension Date {
    func appending(_ components: DateComponents) -> Date {
        return Locale.autoupdatingCurrent.calendar.date(byAdding: components, to: self) ?? self
    }
}
