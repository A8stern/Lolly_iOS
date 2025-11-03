//
//  GameSurveyPresenter.swift
//  LOLLY
//
//  Created by Егор on 03.11.2025.
//

internal protocol GameSurveyPresenter: AnyObject {
    func onViewDidLoad()
    func onCloseTap()
}

final class GameSurveyViewPresenter {
    private unowned let view: GameSurveyView
    private let coordinator: GeneralCoordinator

    init(
        view: GameSurveyView,
        coordinator: GeneralCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

extension GameSurveyViewPresenter: GameSurveyPresenter {
    func onViewDidLoad() { }

    func onCloseTap() {
        coordinator.closeGameSurvey()
    }
}
