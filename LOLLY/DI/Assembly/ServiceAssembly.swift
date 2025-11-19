//
//  ServiceAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

import Foundation

public final class ServiceAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var repositoryAssembly = RepositoryAssembly.instance()

    // MARK: Public Properties

    public var sessionService: SessionServiceInterface {
        define(
            scope: .lazySingleton,
            init: SessionService(
                networkService: self.networkService,
                credentialRepository: self.repositoryAssembly.credentialsRepository
            )
        )
    }

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
                sessionService: self.sessionService,
                isMock: false
            )
        )
    }

    public var stickersService: StickersServiceInterface {
        define(
            scope: .lazySingleton,
            init: StickersService(
                networkService: self.networkService,
                isMock: false
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
