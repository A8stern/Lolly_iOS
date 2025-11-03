//
//  EventManagerInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 03.11.2025.
//

import Foundation

public protocol EventManagerInterface {
    func addEventToCalendar(
        title: String,
        startDate: Date,
        endDate: Date,
        notes: String?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
