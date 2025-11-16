//
//  GameSurveyModels.swift
//  LOLLY
//
//  Created by Егор on 03.11.2025.
//

import Foundation

enum GameSurveyModels {
    enum Start {
        struct ViewModel {
            let title: String
            let subtitle: String?
            let buttonIconURL: URL?
            let backgroundImageURL: URL?
        }
    }

    enum Question {
        struct ViewModel {
            let pageNumber: Int
            let totalPages: Int
            let question: String
            let options: [String]
            let circleSize: CGFloat
        }
    }

    enum Completion {
        struct ViewModel {
            let title: String
            let description: String
            let imageURL: URL?
        }
    }
}
