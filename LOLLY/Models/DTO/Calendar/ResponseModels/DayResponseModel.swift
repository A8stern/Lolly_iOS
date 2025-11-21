//
//  DayResponseModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public struct DayResponseModel: ResponseModel {
    let date: Date
    let events: [EventResponseModel]
}
