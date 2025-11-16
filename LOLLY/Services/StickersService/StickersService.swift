//
//  StickersService.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 08.11.2025.
//

import Foundation

public final class StickersService: StickersServiceInterface {
    private let networkService: NetworkService
    private let isMock: Bool

    // MARK: Lifecycle

    public init(networkService: NetworkService, isMock: Bool) {
        self.networkService = networkService
        self.isMock = isMock
    }

    // MARK: Public Methods

    public func generateHash() async throws -> String {
        if isMock {
            try await Task.sleep(nanoseconds: 1000000000)
            return "HASH"
        }

        let endpoint = StickersEndpoint.generateHash
        let body = EmptyRequestModel()

        let response: GenerateHashResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        return response.hash
    }

    public func changingCheck() async -> ChangingCheckStatus {
        if isMock {
            do {
                try await Task.sleep(nanoseconds: 1000000000)
            } catch {
                return .error
            }
            return .credited
        }

        let endpoint = StickersEndpoint.changingCheck
        let body = EmptyRequestModel()

        do {
            let response: ChangingCheckResponseModel = try await networkService.request(
                endpoint: endpoint.endpoint,
                method: endpoint.method,
                body: body,
                headers: endpoint.headers
            )
            return ChangingCheckStatus(from: response.status)
        } catch {
            if (error as? URLError) != nil {
                return .notChanged
            }
            if let networkError = error as? NetworkClientError {
                switch networkError {
                    case .httpError(let statusCode, _):
                        if statusCode == 204 {
                            return .notChanged
                        }

                    case .emptyBodyExpectedNonEmptyResponse:
                        return .notChanged

                    default:
                        break
                }
            }
            return .error
        }
    }

    public func baristaScan(hash: String) async throws -> Bool {
        if isMock {
            return true
        }

        let endpoint = StickersEndpoint.baristaScan
        let body = BaristaScanRequestModel(hash: hash)

        let _: EmptyResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        return true
    }
}
