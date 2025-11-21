//
//  LoyaltyMapperInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

public protocol LoyaltyMapperInterface: AnyObject {
    func map(_ response: LoyaltyStatusResponseModel) -> LoyaltyStatus
}
