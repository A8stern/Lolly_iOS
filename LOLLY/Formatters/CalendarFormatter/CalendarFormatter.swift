//
//  CalendarFormatter.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.11.2025.
//

import Foundation

public final class CalendarFormatter {
    public var activeLocaleLanguage: Locale = .current

    public init() { }

    private let calendar = Calendar.current

    private func getFormatter(format: DateFormat) -> Foundation.DateFormatter {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = format.getFormat()
        formatter.locale = format.getLocale(default: activeLocaleLanguage)
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

extension DateFormat {
    public func getFormat() -> String {
        switch self {
            case .timeHoursMinutes:
                return "H:mm"

            case .dayMonth:
                return "d MMM"

            case .day:
                return "d"

            case .month:
                return "MMMM"

            case .dayMonthYear:
                return "d MMMM yyyy"

            case .weekHourMinutes:
                return "EEEE, HH:mm"
        }
    }

    fileprivate func getLocale(default: Locale) -> Locale {
        switch self {
            default:
                `default`
        }
    }
}

extension CalendarFormatter: CalendarFormatterInterface {
    public func getDayType(from date: Date) -> DayType {
        let today = Date.now

        if date < today {
            return .past
        } else if date > today {
            return .future
        } else {
            return .current
        }
    }

    public func getFormattedString(from date: Date, format: DateFormat) -> String {
        let formatter = getFormatter(format: format)
        return formatter.string(from: date)
    }

    public func getFormattedDate(from string: String, format: DateFormat) -> Date? {
        let formatter = getFormatter(format: format)
        return formatter.date(from: string)
    }
}
