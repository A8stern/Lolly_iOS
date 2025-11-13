//
//  MainServiceInterface.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

public protocol MainServiceInterface: AnyObject {
    func getContactsData() async throws -> [String: Any]
}
