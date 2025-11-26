//
//  CalendarCellViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

import Foundation

public struct CalendarCellViewModel: Changeable {
    public let rawDate: Date
    public let date: String
    public let type: DayType
    public let isSelected: Bool

    public init(
        rawDate: Date,
        date: String,
        type: DayType,
        isSelected: Bool = false
    ) {
        self.rawDate = rawDate
        self.date = date
        self.type = type
        self.isSelected = isSelected
    }
}

extension CalendarCellViewModel: Equatable {
    public static func == (lhs: CalendarCellViewModel, rhs: CalendarCellViewModel) -> Bool {
        lhs.date == rhs.date && lhs.type == rhs.type
    }
}
