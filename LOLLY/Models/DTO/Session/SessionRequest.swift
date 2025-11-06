//
//  SessionRequest.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

struct SessionRequest: Encodable {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
    }
}
