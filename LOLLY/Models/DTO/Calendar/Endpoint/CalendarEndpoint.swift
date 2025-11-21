//
//  CalendarEndpoint.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public enum CalendarEndpoint: Endpoint {
    case overview

    public var path: String {
        switch self {
            case .overview:
                return "overview"
        }
    }

    public var method: HTTPMethod { .get }

    public var head: PathHeadType { .api }

    public var controller: PathControllerType { .calendar }

    public var headers: [String: String] {
        return [:]
    }
}
