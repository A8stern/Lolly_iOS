//
//  ChangingCheckStatus.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 12.11.2025.
//

import Foundation

public enum ChangingCheckStatus {
    case deducted
    case credited
    case notChanged
    case error

    public init(from statusString: String) {
        let normalized = statusString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
            case "deducted":
                self = .deducted

            case "credited":
                self = .credited

            case "notchanged":
                self = .notChanged

            default:
                self = .error
        }
    }
}
