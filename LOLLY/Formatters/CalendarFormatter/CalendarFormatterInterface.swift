//
//  CalendarFormatterInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.11.2025.
//

import Foundation

public protocol CalendarFormatterInterface: AnyObject {
    var activeLocaleLanguage: Locale { get set }

    func getDayType(from date: Date) -> DayType

    func getFormattedString(from date: Date, format: DateFormat) -> String

    func getFormattedDate(from string: String, format: DateFormat) -> Date?
}
