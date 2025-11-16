//
//  QuizAnswerRequestModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 16.11.2025.
//

public struct QuizAnswerRequestModel: RequestModel {
    public let questionId: Int
    public let optionId: Int
}
