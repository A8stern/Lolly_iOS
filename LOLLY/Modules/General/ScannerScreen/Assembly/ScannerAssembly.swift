//
//  ScannerAssembly.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

internal import UIKit

final class ScannerAssembly: Assembly {
    private lazy var managerAssembly: ManagerAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    func assembleModule(coordinator: GeneralCoordinator) -> ScannerViewController {
        return define(scope: .prototype, init: ScannerViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

extension ScannerAssembly {
    fileprivate func assemblePresenter(view: ScannerView, coordinator: GeneralCoordinator) -> ScannerPresenter {
        return define(
            scope: .prototype,
            init: ScannerViewPresenter(
                view: view,
                coordinator: coordinator,
                stickersService: self.serviceAssembly.stickersService,
                screenBrightnessManager: self.managerAssembly.screenBrightnessManager
            )
        )
    }
}
