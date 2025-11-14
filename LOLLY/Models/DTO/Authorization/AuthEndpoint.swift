//
//  AuthEndpoint.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

public enum AuthEndpoint: Endpoint {
    case checkPhone
    case register
    case sendOTP
    case verifyOTP

    public var path: String {
        switch self {
            case .checkPhone:
                return "is-user"

            case .register:
                return "register"

            case .sendOTP:
                return "send-otp"

            case .verifyOTP:
                return "verify-otp"
        }
    }

    public var method: HTTPMethod {
        switch self {
            case .checkPhone, .sendOTP:
                return .post

            case .register, .verifyOTP:
                return .post
        }
    }

    public var head: PathHeadType { .api }

    public var controller: PathControllerType {
        switch self {
            case .checkPhone, .sendOTP, .verifyOTP:
                return .authorize

            case .register:
                return .user
        }
    }

    public var headers: [String: String] {
        // Добавьте кастомные заголовки, если потребуется.
        // Authorization и Content-Type уже ставит NetworkService.
        return [:]
    }
}
