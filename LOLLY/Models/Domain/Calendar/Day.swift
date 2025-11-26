//
//  Day.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

import Foundation

public struct Day {
    public let date: Date
    public let events: [Event]
}

extension Day: Equatable {
    public static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.date == rhs.date && lhs.events == rhs.events
    }
}
