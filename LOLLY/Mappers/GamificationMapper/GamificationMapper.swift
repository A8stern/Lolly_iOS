//
//  GamificationMapper.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public final class GamificationMapper {
    public init() { }
}

// MARK: - GamificationMapperInterface

extension GamificationMapper: GamificationMapperInterface {
    public func map(_ response: GamificationOverviewResponseModel) -> GamificationOverview {
        GamificationOverview(
            text: response.text,
            imageUrl: URL(string: response.imageURL)
        )
    }
}
