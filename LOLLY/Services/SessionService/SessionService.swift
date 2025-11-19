//
//  SessionService.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

public final class SessionService: SessionServiceInterface {
    // MARK: - Public Properties

    public weak var delegate: SessionServiceDelegate?

    public var networkService: NetworkService

    public var userCredential: UserCredential?

    public var isAuthorised: Bool {
        credentialRepository.accessToken != nil
    }

    // MARK: - Private Properties

    private let credentialRepository: CredentialsRepositoryInterface

    // MARK: - Lifecycle

    public init(
        networkService: NetworkService,
        credentialRepository: CredentialsRepositoryInterface
    ) {
        self.networkService = networkService
        self.credentialRepository = credentialRepository
        updateUserCredentials()
    }

    // MARK: - Public Methods

    public func storeUserCredential(_ credential: UserCredential?) {
        credentialRepository.accessToken = credential?.accessToken
        credentialRepository.refreshToken = credential?.refreshToken
        updateUserCredentials()
    }

    public func refreshUserCredential() async throws -> UserCredential {
        do {
            let requestBody = RefreshTokenRequestModel(refreshToken: credentialRepository.refreshToken)
            let endpoint = AuthEndpoint.refreshToken

            let credential: UserCredential = try await networkService.request(
                endpoint: endpoint.endpoint,
                method: endpoint.method,
                body: requestBody,
                headers: endpoint.headers
            )

            storeUserCredential(credential)
            userCredential?.requiresRefresh = false
            return credential
        } catch let NetworkClientError.httpError(statusCode, _) {
            handleStatusCode(statusCode)
            throw NetworkClientError.httpError(statusCode: statusCode, data: nil)
        } catch {
            throw error
        }
    }

    public func signOut() {
        storeUserCredential(nil)
        delegate?.sessionServiceDidSignOut()
    }
}

// MARK: - Private Methods

private extension SessionService {
    func updateUserCredentials() {
        guard
            let accessToken = credentialRepository.accessToken,
            let refreshToken = credentialRepository.refreshToken
        else {
            userCredential = nil
            return
        }

        userCredential = UserCredential(accessToken: accessToken, refreshToken: refreshToken)
    }

    private func handleStatusCode(_ statusCode: Int) {
        switch statusCode {
            case 400...401:
                signOut()

            case 500:
                userCredential?.requiresRefresh = true

            default:
                break
        }
    }
}
