//
//  LoyaltyMapper.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public final class LoyaltyMapper {
    public init() { }
}

// MARK: - GamificationMapperInterface

extension LoyaltyMapper: LoyaltyMapperInterface {
    public func map(_ response: LoyaltyStatusResponseModel) -> LoyaltyStatus {
        LoyaltyStatus(
            count: response.count,
            total: response.total,
            largeStickerURL: {
                guard let urlString = response.largeStickersUrl else { return nil }
                return URL(string: urlString)
            }(),
            smallStickersURL: response.smallStickersUrl.compactMap { urlString in
                return URL(string: urlString)
            },
            userInternalId: response.userInternalId
        )
    }
}
