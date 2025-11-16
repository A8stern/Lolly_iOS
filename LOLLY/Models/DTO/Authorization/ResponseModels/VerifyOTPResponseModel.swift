//
//  VerifyOTPResponseModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

struct VerifyOTPResponseModel: ResponseModel {
    let accessToken: String
    let refreshToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case refreshToken = "refresh-token"
    }
}
