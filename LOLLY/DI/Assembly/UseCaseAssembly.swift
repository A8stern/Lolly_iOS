//
//  UseCaseAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

public final class UseCaseAssembly: Assembly {
    // MARK: Public Properties

    public var verificationUseCase: VerificationUseCaseInterface {
        define(
            scope: .lazySingleton,
            init: VerificationUseCase()
        )
    }
}
