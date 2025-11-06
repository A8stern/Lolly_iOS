//
//  OtpCodeAssembly.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

@MainActor
final class OtpCodeAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: AuthCoordinator,
        phone: String
    ) -> OtpCodeViewController {
        return define(scope: .prototype, init: OtpCodeViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator, phone: phone)
            return view
        }
    }
}

// MARK: Private Methods

private extension OtpCodeAssembly {
    func assemblePresenter(view: OtpCodeView, coordinator: AuthCoordinator, phone: String) -> OtpCodePresenter {
        return define(
            scope: .prototype,
            init: OtpCodeViewPresenter(
                view: view,
                coordinator: coordinator,
                phone: phone,
                authorizationService: self.serviceAssembly.authorizationService
            )
        )
    }
}
