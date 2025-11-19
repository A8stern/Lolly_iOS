//
//  CredentialsRepository.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import Foundation

public final class CredentialsRepository: CredentialsRepositoryInterface {
    // MARK: Public Properties

    @CryptoKeychain(KeychainKey.userId)
    public var userId: String?

    @CryptoKeychain(KeychainKey.accessToken)
    public var accessToken: String?

    @CryptoKeychain(KeychainKey.refreshToken)
    public var refreshToken: String?

    // MARK: Lifecycle

    public init() { }
}

// MARK: - KeychainKey

private extension CredentialsRepository {
    enum KeychainKey: String {
        case userId
        case accessToken
        case refreshToken
    }
}
