//
//  GameSurveyService.swift
//  LOLLY
//
//  Created by AI Assistant on 12.11.2025.
//

import Foundation

public final class GameSurveyService: GameSurveyServiceInterface {
    // MARK: - Private Properties

    private let networkService: NetworkService

    // MARK: - Lifecycle

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Public Methods

    public func fetchQuiz() async throws -> QuizResponse {
        try await networkService.request(
            endpoint: GamificationEndpoint.quiz.endpoint,
            method: GamificationEndpoint.quiz.method
        )
    }

    public func submitResult(
        userInternalId: String,
        answers: [QuizAnswerRequestModel]
    ) async throws -> QuizResultResponse {
        let body = QuizResultRequest(userInternalId: userInternalId, answers: answers)
        return try await networkService.request(
            endpoint: GamificationEndpoint.result.endpoint,
            method: GamificationEndpoint.result.method,
            body: body
        )
    }

    public func fetchOverview() async throws -> GamificationOverviewResponseModel {
        try await networkService.request(
            endpoint: GamificationEndpoint.overview.endpoint,
            method: GamificationEndpoint.overview.method
        )
    }
}
