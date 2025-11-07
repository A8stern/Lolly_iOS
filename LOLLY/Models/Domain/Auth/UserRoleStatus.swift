//
//  UserRoleStatus.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 05.11.2025.
//

import Foundation

public enum UserRoleStatus: String, Codable, CaseIterable, Sendable {
    case user
    case notRegistered
    case admin
    case barista
    case unknown

    public init(from statusString: String) {
        let normalized = statusString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
            case UserRoleStatus.user.rawValue:
                self = .user

            case UserRoleStatus.notRegistered.rawValue, "notregistered":
                self = .notRegistered

            case UserRoleStatus.admin.rawValue:
                self = .admin

            case UserRoleStatus.barista.rawValue:
                self = .barista

            default:
                self = .unknown
        }
    }

    public init?(validated statusString: String) {
        let normalized = statusString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.init(rawValue: normalized)
    }

    public var statusString: String {
        switch self {
            case .user, .notRegistered, .admin, .barista:
                return rawValue

            case .unknown:
                return "unknown"
        }
    }
}
