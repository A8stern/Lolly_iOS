//
//  RepositoryAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

public final class RepositoryAssembly: Assembly {
    // MARK: Public Properties

    public var credentialsRepository: CredentialsRepositoryInterface {
        define(scope: .lazySingleton, init: CredentialsRepository())
    }
}
