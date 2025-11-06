//
//  VerifyOTPRequest.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

struct VerifyOTPRequest: Encodable {
    let phone: String
    let otp: String
}
