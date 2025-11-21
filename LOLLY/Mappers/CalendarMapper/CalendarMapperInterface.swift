//
//  CalendarMapperInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

public protocol CalendarMapperInterface: AnyObject {
    func map(_ response: CalendarOverviewResponseModel) -> [Day]
}
