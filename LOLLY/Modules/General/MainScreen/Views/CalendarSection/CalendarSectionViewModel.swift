//
//  CalendarSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

import UIKit

public struct CalendarSectionViewModel: Changeable {
    public let isSkeletonable: Bool
    public let month: String?
    public let days: [CalendarCellViewModel]
    public let event: EventViewModel?

    public init(
        isSkeletonable: Bool = false,
        month: String? = nil,
        days: [CalendarCellViewModel] = [],
        event: EventViewModel? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.month = month
        self.days = days
        self.event = event
    }
}
