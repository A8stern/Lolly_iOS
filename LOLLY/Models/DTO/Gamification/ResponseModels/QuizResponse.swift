//
//  QuizResponse.swift
//  LOLLY
//
//  Created by AI Assistant on 12.11.2025.
//

import Foundation

public struct QuizResponse: ResponseModel {
    public let steps: [QuizStepResponseModel]
    public let startText: String
    public let startButtonIcon: String?
}
