//
//  SessionUseCaseInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

// MARK: - Interface

public protocol SessionUseCaseInterface: AnyObject {
    var delegate: SessionUseCaseDelegate? { get set }
    var isAuthorized: Bool { get }
    var credentialsExist: Bool  { get }

    func refreshUserCredential() async throws -> UserCredential
}
