//
//  LoyaltyStatusResponseModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 19.11.2025.
//

import Foundation

public struct LoyaltyStatusResponseModel: ResponseModel {
    let count: Int
    let total: Int
    let largeStickersUrl: String?
    let smallStickersUrl: [String]
    let userInternalId: String
}
