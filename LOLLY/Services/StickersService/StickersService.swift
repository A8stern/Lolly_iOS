//
//  StickersService.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 08.11.2025.
//

import Foundation

public final class StickersService: StickersServiceInterface {
    private let networkService: NetworkService
    private let sessionService: SessionServiceInterface

    // MARK: Lifecycle

    public init(
        networkService: NetworkService,
        sessionService: SessionServiceInterface
    ) {
        self.networkService = networkService
        self.sessionService = sessionService
    }

    // MARK: Public Methods

    public func generateHash() async throws -> String {
        let endpoint = LoyaltyEndpoint.generateHash

        let response: GenerateHashResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: ["Authorization": sessionService.userCredential?.accessToken ?? ""]
        )

        return response.hash
    }

    public func changingCheck() async throws -> ChangingCheckStatus {
        let endpoint = LoyaltyEndpoint.changingCheck
        let body = EmptyRequestModel()

        let response: ChangingCheckResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: ["Authorization": sessionService.userCredential?.accessToken ?? ""]
        )
        return ChangingCheckStatus(from: response.status)
    }

    public func baristaScan(hash: String) async throws -> Bool {
        let endpoint = LoyaltyEndpoint.baristaScan
        let body = BaristaScanRequestModel(hash: hash)

        let _: EmptyResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: ["Authorization": sessionService.userCredential?.accessToken ?? ""]
        )

        return true
    }
}
