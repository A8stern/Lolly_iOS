//
//  ScannerAssembly.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

internal import UIKit

final class ScannerAssembly: Assembly {
    private lazy var managerAssembly: ManagerAssembly = self.context.assembly()

    func assembleModule(coordinator: GeneralCoordinator) -> ScannerViewController {
        return define(scope: .prototype, init: ScannerViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

private extension ScannerAssembly {
    func assemblePresenter(view: ScannerView, coordinator: GeneralCoordinator) -> ScannerPresenter {
        return define(
            scope: .prototype,
            init: ScannerViewPresenter(
                view: view,
                coordinator: coordinator,
                screenBrightnessManager: self.managerAssembly.screenBrightnessManager
            )
        )
    }
}
