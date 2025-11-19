//
//  SessionUseCase.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import Foundation

public final class SessionUseCase: SessionUseCaseInterface {
    // MARK: - Public Properties

    public weak var delegate: SessionUseCaseDelegate?

    public var isAuthorized: Bool {
        sessionService.isAuthorised
    }

    public var credentialsExist: Bool {
        sessionService.userCredential != nil
    }

    // MARK: - Private Properties

    private let sessionService: SessionServiceInterface

    // MARK: - Lifecycle

    public init(sessionService: SessionServiceInterface) {
        self.sessionService = sessionService
        self.sessionService.delegate = self
    }

    public func refreshUserCredential() async throws -> UserCredential {
        try await sessionService.refreshUserCredential()
    }
}

// MARK: - SessionServiceDelegate

extension SessionUseCase: SessionServiceDelegate {
    public func sessionServiceDidSignOut() {
        delegate?.sessionUseCaseDidSignOut()
    }
}
