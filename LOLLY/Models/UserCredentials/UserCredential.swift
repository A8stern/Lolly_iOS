//
//  UserCredential.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import Foundation

public struct UserCredential: ResponseModel, Equatable, Hashable, AuthenticationCredential {
    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
        case refreshToken
    }

    // MARK: - Public Properties

    public static let empty = UserCredential(accessToken: "", refreshToken: "")

    public let accessToken: String
    public let refreshToken: String
    public var requiresRefresh: Bool = false

    // MARK: - Lifecycle

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
