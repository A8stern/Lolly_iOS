//
//  ProfileInfoResponseModel.swift
//  LOLLY
//
//  Created by AI Assistant on 15.11.2025.
//

import Foundation

public struct ProfileInfoResponseModel: ResponseModel, Codable {
    public let name: String
    public let phone: String

    public init(name: String, phone: String) {
        self.name = name
        self.phone = phone
    }
}

