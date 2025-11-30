//
//  StickersEndpoint.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 12.11.2025.
//

import Foundation

public enum LoyaltyEndpoint: Endpoint {
    case generateHash
    case changingCheck
    case baristaScan
    case status

    public var path: String {
        switch self {
            case .generateHash:
                return "qr"

            case .changingCheck:
                return "changing-check"

            case .baristaScan:
                return "scan"

            case .status:
                return "status"
        }
    }

    public var method: HTTPMethod {
        switch self {
            case .generateHash, .changingCheck, .status:
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

            case .changingCheck, .status:
                return .loyalty

            case .baristaScan:
                return .barista
        }
    }

    public var headers: [String: String] {
        return [:]
    }
}
