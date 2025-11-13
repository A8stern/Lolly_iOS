//
//  VerifyOTPRequestModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

struct VerifyOTPRequestModel: RequestModel {
    let phone: String
    let otp: String
}
