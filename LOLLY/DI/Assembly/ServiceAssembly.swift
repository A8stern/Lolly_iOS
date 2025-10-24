//
//  ServiceAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

public final class ServiceAssembly: Assembly {
    // MARK: Public Properties

    public var authorizationService: AuthorizationServiceInterface {
        define(
            scope: .lazySingleton,
            init: AuthorizationService()
        )
    }
}
