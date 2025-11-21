//
//  MarketingEndpoint.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

import Foundation

public enum MarketingEndpoint: Endpoint {
    case slider
    case afisha

    public var path: String {
        switch self {
            case .slider:
                return "slider"

            case .afisha:
                return "afisha"
        }
    }

    public var method: HTTPMethod { .get }

    public var head: PathHeadType { .api }

    public var controller: PathControllerType { .marketing }

    public var headers: [String: String] {
        // Добавьте кастомные заголовки, если потребуется.
        // Authorization и Content-Type уже ставит NetworkService.
        return [:]
    }
}
