//
//  QuizStepResponseModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 16.11.2025.
//

public struct QuizStepResponseModel: ResponseModel {
    public let id: Int
    public let question: String
    public let options: [QuizOptionResponseModel]
}
