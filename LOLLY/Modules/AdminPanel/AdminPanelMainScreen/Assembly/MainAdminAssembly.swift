//
//  MainAdminAssembly.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

internal import UIKit

final class MainAdminAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: AdminCoordinator,
        phone: String
    ) -> AdminViewController {
        return define(scope: .prototype, init: AdminViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator, phone: phone)
            return view
        }
    }
}

// MARK: Private Methods

extension MainAdminAssembly {
    fileprivate func assemblePresenter(
        view: AdminView,
        coordinator: AdminCoordinator,
        phone: String
    ) -> AdminPresenter {
        return define(
            scope: .prototype,
            init: AdminViewPresenter(
                view: view,
                coordinator: coordinator,
                authorizationService: self.serviceAssembly.authorizationService,
                phone: phone
            )
        )
    }
}
