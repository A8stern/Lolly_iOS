//
//  StickersEndpoint.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 12.11.2025.
//

import Foundation

public enum StickersEndpoint: Endpoint {
    case generateHash
    case changingCheck
    case baristaScan

    public var path: String {
        switch self {
            case .generateHash:
                return "qr"

            case .changingCheck:
                return "/loyalty/changing-check"

            case .baristaScan:
                return "/barista/scan"
        }
    }

    public var method: HTTPMethod {
        switch self {
            case .generateHash, .changingCheck:
                return .get

            case .baristaScan:
            return .post
        }
    }

    public var head: PathHeadType { .api }

    public var controller: PathControllerType {
        switch self {
            case .generateHash:
                return .profile

            case .changingCheck:
                return .loyalty

            case .baristaScan:
                return .barista
        }
    }

    public var headers: [String: String] {
        return [:]
    }
}

extension StickersEndpoint {
    public var endpoint: String { path }
}
