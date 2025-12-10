//
//  AuthorizationService.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

import Foundation
private import PhoneNumberKit

public final class AuthorizationService: AuthorizationServiceInterface {
    private let networkService: NetworkService
    private let sessionService: SessionServiceInterface
    private let phoneNumberKit = PhoneNumberUtility()
    private let isMock: Bool

    // MARK: Lifecycle

    public init(
        networkService: NetworkService,
        sessionService: SessionServiceInterface,
        isMock: Bool
    ) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.isMock = isMock
    }

    // MARK: Public Methods

    public func signIn() { }

    public func fetchUserStatus(phone: String) async throws -> UserRoleStatus {
        if isMock {
            return .admin
        }

        let formattedPhone = try validateAndFormatPhone(phone)
        let requestBody = PhoneCheckRequestModel(phone: formattedPhone)

        let endpoint = AuthEndpoint.checkPhone
        let answer: PhoneCheckResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: requestBody,
            headers: endpoint.headers
        )
        print("LALALA status from request: \(answer.status)")
        return UserRoleStatus(from: answer.status)
    }

    public func registerNewAccount(phone: String, name: String) async throws -> Bool {
        if isMock {
            return true
        }

        let formattedPhone = try validateAndFormatPhone(phone)

        let body = RegisterRequestModel(phone: formattedPhone, name: name)
        let endpoint = AuthEndpoint.register

        let _: EmptyResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )
        return true
    }

    public func otpRequest(phone: String) async throws -> Bool {
        if isMock {
            return true
        }

        let formattedPhone = try validateAndFormatPhone(phone)

        let body = OTPRequestModel(phone: formattedPhone)
        let endpoint = AuthEndpoint.sendOTP

        let _: EmptyResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )
        return true
    }

    public func otpVerify(phone: String, otp: String) async throws -> Bool {
        if isMock {
            if otp == "0000" {
                return true
            } else {
                return false
            }
        }

        let formattedPhone = try validateAndFormatPhone(phone)

        let endpoint = AuthEndpoint.verifyOTP
        let body = VerifyOTPRequestModel(phone: formattedPhone, otp: otp)

        let response: VerifyOTPResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        sessionService.storeUserCredential(
            UserCredential(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
        )

        return true
    }
}

// MARK: - Private helpers

extension AuthorizationService {
    fileprivate func validateAndFormatPhone(_ rawPhone: String) throws -> String {
        do {
            let parsed = try phoneNumberKit.parse(rawPhone)
            return phoneNumberKit.format(parsed, toType: .e164)
        } catch {
            throw NSError(
                domain: "AuthorizationService",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: "Invalid phone number"]
            )
        }
    }
}
