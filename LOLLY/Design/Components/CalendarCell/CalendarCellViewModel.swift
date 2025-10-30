//
//  CalendarCellViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

public struct CalendarCellViewModel: Changeable {
    public enum DayType {
        case past
        case current
        case future
    }

    public let date: Int
    public let type: DayType

    public init(date: Int, type: DayType) {
        self.date = date
        self.type = type
    }
}
