//
//  GamificationMapperInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

public protocol GamificationMapperInterface: AnyObject {
    func map(_ response: GamificationOverviewResponseModel) -> GamificationOverview
}
