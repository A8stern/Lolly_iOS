//
//  UseCaseAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

public final class UseCaseAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Public Properties

    public var verificationUseCase: VerificationUseCaseInterface {
        define(
            scope: .lazySingleton,
            init: VerificationUseCase()
        )
    }

    public var sessionUseCase: SessionUseCaseInterface {
        define(
            scope: .lazySingleton,
            init: SessionUseCase(
                sessionService: self.serviceAssembly.sessionService
            )
        )
    }
}
