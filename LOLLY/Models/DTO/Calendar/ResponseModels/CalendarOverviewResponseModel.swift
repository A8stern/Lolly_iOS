//
//  CalendarOverviewResponseModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 19.11.2025.
//

import Foundation

public struct CalendarOverviewResponseModel: ResponseModel {
    let days: [DayResponseModel]
}
