//
//  LoyaltyLoadingInput.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.11.2025.
//

public struct LoyaltyLoadingInput {
    public let status: ChangingCheckStatus

    public init(status: ChangingCheckStatus) {
        self.status = status
    }
}
