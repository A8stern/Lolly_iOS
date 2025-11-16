//
//  GamificationEndpoint.swift
//  LOLLY
//
//  Created by AI Assistant on 12.11.2025.
//

import Foundation

enum GamificationEndpoint: Endpoint {
    case quiz
    case result
    case overview

    var path: String {
        switch self {
            case .quiz:
                return "quiz"

            case .result:
                return "quiz/result"

            case .overview:
                return "overview"
        }
    }

    var method: HTTPMethod {
        switch self {
            case .quiz, .overview:
                return .get

            case .result:
                return .post
        }
    }

    var headers: [String: String] { [:] }

    var head: PathHeadType { .api }

    var controller: PathControllerType { .gamification }
}
