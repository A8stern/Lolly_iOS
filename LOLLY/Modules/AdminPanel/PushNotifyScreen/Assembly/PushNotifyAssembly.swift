//
//  PushNotifyAssembly.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

internal import UIKit

final class PushNotifyAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: AdminCoordinator
    ) -> PushNotifyViewController {
        return define(scope: .prototype, init: PushNotifyViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

extension PushNotifyAssembly {
    fileprivate func assemblePresenter(
        view: PushNotifyView,
        coordinator: AdminCoordinator
    ) -> PushNotifyPresenter {
        return define(
            scope: .prototype,
            init: PushNotifyViewPresenter(
                view: view,
                coordinator: coordinator,
                authorizationService: serviceAssembly.authorizationService
            )
        )
    }
}
