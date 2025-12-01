//
//  QRScanAssembly.swift
//  Brewsell
//
//  Created by Kovalev Gleb on 29.11.2025.
//

internal import UIKit

final class QRScanAssembly: Assembly {
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    func assembleModule(
        coordinator: AdminCoordinator,
        serviceAssembly: ServiceAssembly
    ) -> QRScanViewController {
        return define(scope: .prototype, init: QRScanViewController()) { view in
            view.presenter = self.assemblePresenter(
                view: view,
                coordinator: coordinator
            )
            return view
        }
    }
}

private extension QRScanAssembly {
    func assemblePresenter(
        view: QRScanView,
        coordinator: AdminCoordinator
    ) -> QRScanPresenter {
        return define(
            scope: .prototype,
            init: QRScanViewPresenter(
                view: view,
                coordinator: coordinator,
                service: self.serviceAssembly.stickersService
            )
        )
    }
}
