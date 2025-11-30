//
//  ProfileServiceInterface.swift
//  LOLLY
//
//  Created by AI Assistant on 15.11.2025.
//

import Foundation

public protocol ProfileServiceInterface {
    func getProfileInfo() async throws -> ProfileInfoResponseModel
}
