//
//  AuthEndpoint.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

public enum AuthEndpoint {
    case checkPhone
    case register
    case sendOTP
    case verifyOTP

    public var path: String {
        switch self {
        case .checkPhone:
            return "/check-phone"

        case .register:
            return "/authorize/register"

        case .sendOTP:
            return "/authorize/send-otp"

        case .verifyOTP:
            return "/authorize/verify-otp"
        }
    }

    public var method: String {
        switch self {
        case .checkPhone, .sendOTP:
            return "GET"

        case .register, .verifyOTP:
            return "POST"
        }
    }

    public var headers: [String: String] {
        // Добавьте кастомные заголовки, если потребуется.
        // Authorization и Content-Type уже ставит NetworkService.
        return [:]
    }
}

public extension AuthEndpoint {
    var endpoint: String { path }
}
