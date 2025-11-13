//
//  MainAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

final class MainAssembly: Assembly {
    // MARK: - Private Properties

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: GeneralCoordinator,
        mainService: MainServiceInterface
    ) -> MainViewController {
        return define(scope: .prototype, init: MainViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator, mainService: mainService)
            return view
        }
    }
}

// MARK: Private Methods

extension MainAssembly {
    fileprivate func assemblePresenter(
        view: MainView,
        coordinator: GeneralCoordinator,
        mainService: MainServiceInterface
    ) -> MainPresenter {
        return define(
            scope: .prototype,
            init: MainViewPresenter(
                view: view,
                coordinator: coordinator,
                mainService: mainService
            )
        )
    }
}
