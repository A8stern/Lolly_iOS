//
//  SessionEndpoint.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

public enum SessionEndpoint {
    case checkToken

    public var path: String {
        switch self {
            case .checkToken:
                return "/authorize/token"
        }
    }

    public var method: String {
        switch self {
            case .checkToken:
                return "GET"
        }
    }

    public var headers: [String: String] {
        // Добавьте кастомные заголовки, если потребуется.
        // Authorization и Content-Type уже ставит NetworkService.
        return [:]
    }
}

extension SessionEndpoint {
    public var endpoint: String { path }
}
