//
//  CredentialsRepositoryInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import Foundation

public protocol CredentialsRepositoryInterface: AnyObject {
    var userId: String? { get set }
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

public extension CredentialsRepositoryInterface {
    var isAuthorized: Bool {
        accessToken != nil
    }
}
