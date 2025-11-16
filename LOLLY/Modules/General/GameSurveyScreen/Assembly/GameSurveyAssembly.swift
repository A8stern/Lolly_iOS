//
//  GameSurveyAssembly.swift
//  LOLLY
//
//  Created by Егор on 03.11.2025.
//

internal import UIKit

final class GameSurveyAssembly: Assembly {
    func assembleModule(
        coordinator: GeneralCoordinator,
        serviceAssembly: ServiceAssembly
    ) -> GameSurveyViewController {
        return define(scope: .prototype, init: GameSurveyViewController()) { view in
            view.presenter = self.assemblePresenter(
                view: view,
                coordinator: coordinator,
                service: serviceAssembly.gameSurveyService
            )
            return view
        }
    }
}

private extension GameSurveyAssembly {
    func assemblePresenter(
        view: GameSurveyView,
        coordinator: GeneralCoordinator,
        service: GameSurveyServiceInterface
    ) -> GameSurveyPresenter {
        return define(
            scope: .prototype,
            init: GameSurveyViewPresenter(
                view: view,
                coordinator: coordinator,
                gameSurveyService: service
            )
        )
    }
}
