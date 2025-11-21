//
//  MarketingMapper.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public final class MarketingMapper {
    public init() { }
}

// MARK: - GamificationMapperInterface

extension MarketingMapper: MarketingMapperInterface {
    public func map(_ response: SliderResponseModel) -> [SliderCard] {
        response.cards.map { SliderCard(model: $0) }
    }
}
