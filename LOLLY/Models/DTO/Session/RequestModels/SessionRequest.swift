//
//  SessionRequestModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

struct SessionRequestModel: RequestModel {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
    }
}
