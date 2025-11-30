//
//  ProfileEndpoint.swift
//  LOLLY
//
//  Created by AI Assistant on 15.11.2025.
//

import Foundation

public enum ProfileEndpoint: Endpoint {
    case info

    public var path: String {
        switch self {
            case .info:
                return "info"
        }
    }

    public var method: HTTPMethod {
        switch self {
            case .info:
                return .get
        }
    }

    public var head: PathHeadType { .api }

    public var controller: PathControllerType { .profile }

    public var headers: [String: String] {
        return [:]
    }
}
