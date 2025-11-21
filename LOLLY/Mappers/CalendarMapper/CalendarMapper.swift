//
//  CalendarMapper.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public final class CalendarMapper {
    public init() { }

    private func mapDay(_ response: DayResponseModel) -> Day {
        Day(
            date: response.date,
            events: response.events.map { mapEvent($0) }
        )
    }

    private func mapEvent(_ response: EventResponseModel) -> Event {
        Event(
            time: response.date.timeIntervalSince1970,
            name: response.name
        )
    }
}

// MARK: - CalendarMapperInterface

extension CalendarMapper: CalendarMapperInterface {
    public func map(_ response: CalendarOverviewResponseModel) -> [Day] {
        response.days.map { mapDay($0) }
    }
}
