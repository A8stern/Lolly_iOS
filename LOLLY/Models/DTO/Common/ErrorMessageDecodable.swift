//
//  ErrorMessageDecodable.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 12.11.2025.
//

import Foundation

struct ErrorMessageDecodable: Error, Decodable {
    let message: String
}
