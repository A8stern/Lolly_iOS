//
//  FormatterAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.11.2025.
//

public final class FormatterAssembly: Assembly {
    // MARK: Public Properties

    public var calendarFormatter: CalendarFormatterInterface {
        define(
            scope: .prototype,
            init: CalendarFormatter()
        )
    }
}
