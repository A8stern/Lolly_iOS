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

    func assembleModule(coordinator: GeneralCoordinator) -> LoyaltyLoadingViewController {
        return define(scope: .prototype, init: LoyaltyLoadingViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

extension LoyaltyLoadingAssembly {
    fileprivate func assemblePresenter(view: LoyaltyLoadingView, coordinator: GeneralCoordinator) -> LoyaltyLoadingPresenter {
        return define(
            scope: .prototype,
            init: LoyaltyLoadingViewPresenter(
                view: view,
                coordinator: coordinator,
                service: self.serviceAssembly.stickersService
            )
        )
    }
}
