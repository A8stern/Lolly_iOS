//
//  EventManager.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 03.11.2025.
//

import EventKit
import Foundation

public final class EventManager {
    let eventStore: EKEventStore = .init()

    public init() { }
}

// MARK: - EventManagerInterface

extension EventManager: EventManagerInterface {
    public func addEventToCalendar(
        title: String,
        startDate: Date,
        endDate: Date,
        notes: String?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            guard granted, error == nil else {
                if let error {
                    completion(.failure(error))
                } else {
                    completion(
                        .failure(
                            NSError(
                                domain: "CalendarAccess",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Access denied"]
                            )
                        )
                    )
                }
                return
            }

            guard let self else { return }

            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.notes = notes
            event.calendar = eventStore.defaultCalendarForNewEvents

            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
