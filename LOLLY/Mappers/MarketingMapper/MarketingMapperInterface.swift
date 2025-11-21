//
//  MarketingMapperInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

public protocol MarketingMapperInterface: AnyObject {
    func map(_ response: SliderResponseModel) -> [SliderCard]
}
