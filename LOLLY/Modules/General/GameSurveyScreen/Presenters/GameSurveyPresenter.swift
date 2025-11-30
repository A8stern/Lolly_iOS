//
//  GameSurveyPresenter.swift
//  LOLLY
//
//  Created by Егор on 03.11.2025.
//

import Foundation
import UIKit

protocol GameSurveyPresenter: AnyObject {
    func onViewDidLoad()
    func onCloseTap()
    func onStartTap()
    func onOptionSelected(_ optionIndex: Int)
    func onRestartTap()
}

final class GameSurveyViewPresenter {
    private unowned let view: GameSurveyView
    private let coordinator: GeneralCoordinator
    private let gameSurveyService: GameSurveyServiceInterface

    // MARK: - State

    private var currentQuestionIndex: Int = 0
    private var quiz: QuizResponse?
    private var selectedAnswers: [QuizAnswerRequestModel] = []

    private var userInternalId: String {
        if let savedId = UserDefaults.standard.string(forKey: Constants.userIDKey) {
            return savedId
        }

        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: Constants.userIDKey)
        return newId
    }

    init(
        view: GameSurveyView,
        coordinator: GeneralCoordinator,
        gameSurveyService: GameSurveyServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.gameSurveyService = gameSurveyService
    }
}

extension GameSurveyViewPresenter: GameSurveyPresenter {
    func onViewDidLoad() {
        loadInitialData()
    }

    func onCloseTap() {
        coordinator.closeGameSurvey()
    }

    func onStartTap() {
        guard let quiz, quiz.steps.isEmpty == false else {
            loadInitialData()
            view.showSnack(with: .warning(text: L10n.Gamification.error))
            return
        }

        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        showCurrentQuestion()
    }

    func onOptionSelected(_ optionIndex: Int) {
        guard let quiz, currentQuestionIndex < quiz.steps.count else {
            return
        }

        let step = quiz.steps[currentQuestionIndex]
        guard optionIndex >= 0, optionIndex < step.options.count else {
            return
        }

        let option = step.options[optionIndex]
        let answer = QuizAnswerRequestModel(questionId: step.id, optionId: option.id)
        selectedAnswers.append(answer)

        currentQuestionIndex += 1

        if currentQuestionIndex < quiz.steps.count {
            showCurrentQuestion()
        } else {
            submitResults()
        }
    }

    func onRestartTap() {
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        loadInitialData()
    }
}

// MARK: - Private Methods

extension GameSurveyViewPresenter {
    fileprivate func loadInitialData() {
        view.setLoading(true)

        Task {
            do {
                async let quizTask = gameSurveyService.fetchQuiz()
                async let overviewTask = gameSurveyService.fetchOverview()

                let (quizResponse, overview) = try await (quizTask, overviewTask)
                quiz = quizResponse

                await MainActor.run {
                    let viewModel = GameSurveyModels.Start.ViewModel(
                        title: quizResponse.startText,
                        subtitle: overview.text,
                        buttonIconURL: URL(string: quizResponse.startButtonIcon ?? ""),
                        backgroundImageURL: URL(string: overview.imageURL)
                    )
                    view.configureStart(viewModel: viewModel)
                    view.showStartScreen()
                }
            } catch {
                await MainActor.run {
                    view.showSnack(with: .error(text: error.readableDescription))
                    view.showStartScreen()
                }
            }

            await MainActor.run {
                view.setLoading(false)
            }
        }
    }

    fileprivate func showCurrentQuestion() {
        guard let quiz, currentQuestionIndex < quiz.steps.count else {
            return
        }

        let step = quiz.steps[currentQuestionIndex]
        let options = step.options.map(\.text)
        let size = circleSize(for: currentQuestionIndex, total: quiz.steps.count)

        let viewModel = GameSurveyModels.Question.ViewModel(
            pageNumber: currentQuestionIndex + 1,
            totalPages: quiz.steps.count,
            question: step.question,
            options: options,
            circleSize: size
        )
        view.showQuestion(viewModel: viewModel)
    }

    fileprivate func submitResults() {
        view.setLoading(true)

        let answers = selectedAnswers
        Task {
            do {
                let result = try await gameSurveyService.submitResult(
                    userInternalId: userInternalId,
                    answers: answers
                )

                await MainActor.run {
                    let viewModel = GameSurveyModels.Completion.ViewModel(
                        title: result.title,
                        description: result.description,
                        imageURL: URL(string: result.imageURL)
                    )
                    view.showCompletion(viewModel: viewModel)
                }
            } catch {
                await MainActor.run {
                    view.showSnack(with: .error(text: error.readableDescription))
                    view.showStartScreen()
                }
            }

            await MainActor.run {
                view.setLoading(false)
            }
        }
    }

    fileprivate func circleSize(for index: Int, total: Int) -> CGFloat {
        let maxSize: CGFloat = 300
        let minSize: CGFloat = 120
        guard total > 1 else { return maxSize }
        let step = (maxSize - minSize) / CGFloat(total - 1)
        return max(maxSize - step * CGFloat(index), minSize)
    }
}

// MARK: - Constants

extension GameSurveyViewPresenter {
    fileprivate enum Constants {
        static let userIDKey = "GameSurveyUserInternalId"
    }
}
