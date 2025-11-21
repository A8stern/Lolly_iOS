//
//  MapperAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

public final class MapperAssembly: Assembly {
    // MARK: Public Properties

    public var calendarMapper: CalendarMapperInterface {
        define(
            scope: .prototype,
            init: CalendarMapper()
        )
    }

    public var gamificationMapper: GamificationMapperInterface {
        define(
            scope: .prototype,
            init: GamificationMapper()
        )
    }

    public var loyaltyMapper: LoyaltyMapperInterface {
        define(
            scope: .prototype,
            init: LoyaltyMapper()
        )
    }

    public var marketingMapper: MarketingMapperInterface {
        define(
            scope: .prototype,
            init: MarketingMapper()
        )
    }
}
