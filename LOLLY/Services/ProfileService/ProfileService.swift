//
//  ProfileService.swift
//  LOLLY
//
//  Created by AI Assistant on 15.11.2025.
//

import Foundation

public final class ProfileService: ProfileServiceInterface {
    // MARK: - Private Properties

    private let networkService: NetworkService

    // MARK: - Lifecycle

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Public Methods

    public func getProfileInfo() async throws -> ProfileInfoResponseModel {
        let endpoint = ProfileEndpoint.info
        return try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )
    }
}

