//
//  CalendarSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

import UIKit

public struct CalendarSectionViewModel: Changeable {
    public let month: String
    public let days: [CalendarCellViewModel]
    public let event: EventViewModel?

    public init(
        month: String,
        days: [CalendarCellViewModel],
        event: EventViewModel?
    ) {
        self.month = month
        self.days = days
        self.event = event
    }
}
