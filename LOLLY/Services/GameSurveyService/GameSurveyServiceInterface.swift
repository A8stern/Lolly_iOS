//
//  GameSurveyServiceInterface.swift
//  LOLLY
//
//  Created by AI Assistant on 12.11.2025.
//

import Foundation

public protocol GameSurveyServiceInterface: AnyObject {
    func fetchQuiz() async throws -> QuizResponse
    func submitResult(
        userInternalId: String,
        answers: [QuizAnswerRequestModel]
    ) async throws -> QuizResultResponse
    func fetchOverview() async throws -> GamificationOverviewResponse
}
