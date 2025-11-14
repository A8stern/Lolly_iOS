//
//  SessionEndpoint.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

public enum SessionEndpoint: Endpoint {
    case checkToken

    public var path: String {
        switch self {
            case .checkToken:
                return "token"
        }
    }

    public var method: HTTPMethod {
        switch self {
            case .checkToken:
                return .get
        }
    }

    public var head: PathHeadType { .api }

    public var controller: PathControllerType { .authorize }

    public var headers: [String: String] {
        // Добавьте кастомные заголовки, если потребуется.
        // Authorization и Content-Type уже ставит NetworkService.
        return [:]
    }
}

extension SessionEndpoint {
    public var endpoint: String { path }
}
