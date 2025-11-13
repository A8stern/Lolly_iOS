//
//  ContactsEndPoint.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

import Foundation

public enum ContactsEndPoint {
    case getContactsData

    public var path: String {
        switch self {
            case .getContactsData:
                return "organization/information"
        }
    }

    public var method: String {
        switch self {
            case .getContactsData:
                return "GET"
        }
    }

    public var headers: [String: String] {
        return [:]
    }
}

extension ContactsEndPoint {
    public var endpoint: String { path }
}
