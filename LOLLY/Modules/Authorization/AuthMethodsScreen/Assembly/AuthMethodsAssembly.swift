//
//  AuthMethodsAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

internal import UIKit

final class AuthMethodsAssembly: Assembly {
    // MARK: - Internal Methods

    func assembleModule(
        coordinator: AuthCoordinator
    ) -> AuthMethodsViewController {
        return define(scope: .prototype, init: AuthMethodsViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

extension AuthMethodsAssembly {
    fileprivate func assemblePresenter(view: AuthMethodsView, coordinator: AuthCoordinator) -> AuthMethodsPresenter {
        return define(
            scope: .prototype,
            init: AuthMethodsViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }
}
