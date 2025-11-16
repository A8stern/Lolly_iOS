//
//  ServiceAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

import Foundation

public final class ServiceAssembly: Assembly {
    // MARK: Public Properties

    public var networkService: NetworkService {
        define(
            scope: .lazySingleton,
            init: NetworkService(
                session: .shared
            )
        )
    }

    public var authorizationService: AuthorizationServiceInterface {
        define(
            scope: .lazySingleton,
            init: AuthorizationService(
                networkService: self.networkService,
                isMock: true
            )
        )
    }

    public var stickersService: StickersServiceInterface {
        define(
            scope: .lazySingleton,
            init: StickersService(
                networkService: self.networkService,
                isMock: true
            )
        )
    }

    public var gameSurveyService: GameSurveyServiceInterface {
        define(
            scope: .lazySingleton,
            init: GameSurveyService(
                networkService: self.networkService
            )
        )
    }
}
