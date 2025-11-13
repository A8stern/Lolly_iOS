//
//  ContactsEndPoint.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

import Foundation

public enum ContactsEndPoint: Endpoint {
    case getContactsData

    public var path: String {
        switch self {
            case .getContactsData:
                return "organization/information"
        }
    }

    public var method: HTTPMethod {
        switch self {
            case .getContactsData:
                return .get
        }
    }

    public var headers: [String: String] {
        return [:]
    }
}
