//
//  PhoneLogInAssembly.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

@MainActor
final class PhoneLogInAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: AuthCoordinator
    ) -> PhoneLogInViewController {
        return define(scope: .prototype, init: PhoneLogInViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

extension PhoneLogInAssembly {
    fileprivate func assemblePresenter(
        view: PhoneLogInView,
        coordinator: AuthCoordinator
    ) -> PhoneLogInPresenter {
        return define(
            scope: .prototype,
            init: PhoneLogInViewPresenter(
                view: view,
                coordinator: coordinator,
                authorizationService: self.serviceAssembly.authorizationService
            )
        )
    }
}
