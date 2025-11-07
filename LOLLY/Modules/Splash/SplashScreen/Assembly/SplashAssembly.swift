//
//  SplashAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

import Foundation

final class SplashAssembly: Assembly {
    // MARK: - Private Properties

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: SplashCoordinator
    ) -> SplashViewController {
        return define(scope: .prototype, init: SplashViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: - Private Methods

extension SplashAssembly {
    fileprivate func assemblePresenter(view: SplashView, coordinator: SplashCoordinator) -> SplashPresenter {
        return define(
            scope: .prototype,
            init: SplashViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }
}
