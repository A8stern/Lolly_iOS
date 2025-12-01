//
//  LoyaltyLoadingAssembly.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 08.11.2025.
//

internal import UIKit

final class LoyaltyLoadingAssembly: Assembly {
    private lazy var managerAssembly: ManagerAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    func assembleModule(input: LoyaltyLoadingInput, coordinator: GeneralCoordinator) -> LoyaltyLoadingViewController {
        return define(scope: .prototype, init: LoyaltyLoadingViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator, input: input)
            return view
        }
    }

    func assembleAdminModule(coordinator: AdminCoordinator) -> LoyaltyLoadingViewController {
        return define(scope: .prototype, init: LoyaltyLoadingViewController()) { view in
            view.presenter = self.assembleAdminPresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

extension LoyaltyLoadingAssembly {
    fileprivate func assembleAdminPresenter(
        view: LoyaltyLoadingView,
        coordinator: AdminCoordinator
    ) -> LoyaltyLoadingPresenter {
        return define(
            scope: .prototype,
            init: AdminLoyaltyLoadingViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }

    fileprivate func assemblePresenter(
        view: LoyaltyLoadingView,
        coordinator: GeneralCoordinator,
        input: LoyaltyLoadingInput
    ) -> LoyaltyLoadingPresenter {
        return define(
            scope: .prototype,
            init: LoyaltyLoadingViewPresenter(
                view: view,
                input: input,
                coordinator: coordinator,
                service: self.serviceAssembly.stickersService
            )
        )
    }
}
