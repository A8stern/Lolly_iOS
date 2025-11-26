//
//  DateFormat.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.11.2025.
//

public enum DateFormat: String, CaseIterable {
    /// "H:mm", ex. "12:10"
    case timeHoursMinutes

    /// "d MMM"
    case dayMonth

    /// "MMMM" local, ex. "MAY"
    case month

    /// "d" local, ex. "23"
    case day

    /// "d MMMM yyyy"
    case dayMonthYear

    /// "EEEE, HH:mm", ex. Saturday, 15:30
    case weekHourMinutes
}
