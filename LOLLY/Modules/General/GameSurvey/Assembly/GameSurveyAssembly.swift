//
//  GameSurveyAssembly.swift
//  LOLLY
//
//  Created by Егор on 03.11.2025.
//

internal import UIKit

final class GameSurveyAssembly: Assembly {
    func assembleModule(
        coordinator: GeneralCoordinator
    ) -> GameSurveyViewController {
        return define(scope: .prototype, init: GameSurveyViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

extension GameSurveyAssembly {
    fileprivate func assemblePresenter(
        view: GameSurveyView,
        coordinator: GeneralCoordinator
    ) -> GameSurveyPresenter {
        return define(
            scope: .prototype,
            init: GameSurveyViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }
}
