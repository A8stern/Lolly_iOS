//
//  RegisterRequest.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 04.11.2025.
//

import Foundation

struct RegisterRequest: Encodable {
    let phone: String
    let name: String
}
