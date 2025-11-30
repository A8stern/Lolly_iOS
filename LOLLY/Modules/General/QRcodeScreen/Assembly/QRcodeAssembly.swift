//
//  QRcodeAssembly.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

internal import UIKit

final class QRcodeAssembly: Assembly {
    private lazy var managerAssembly: ManagerAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    func assembleModule(coordinator: GeneralCoordinator) -> QRcodeViewController {
        return define(scope: .prototype, init: QRcodeViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

extension QRcodeAssembly {
    fileprivate func assemblePresenter(view: QRcodeView, coordinator: GeneralCoordinator) -> QRcodePresenter {
        return define(
            scope: .prototype,
            init: QRcodeViewPresenter(
                view: view,
                coordinator: coordinator,
                stickersService: self.serviceAssembly.stickersService,
                screenBrightnessManager: self.managerAssembly.screenBrightnessManager
            )
        )
    }
}
