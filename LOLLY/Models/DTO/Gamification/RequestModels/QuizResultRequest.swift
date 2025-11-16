//
//  QuizResultRequest.swift
//  LOLLY
//
//  Created by AI Assistant on 12.11.2025.
//

import Foundation

public struct QuizResultRequest: RequestModel {
    public let userInternalId: String
    public let answers: [QuizAnswerRequestModel]
}
