//
//  StickersServiceInterface.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 08.11.2025.
//

import Foundation

public protocol StickersServiceInterface: AnyObject {
    func generateHash() async throws -> String
    func changingCheck() async -> ChangingCheckStatus
    func baristaScan(hash: String) async throws -> Bool
}
