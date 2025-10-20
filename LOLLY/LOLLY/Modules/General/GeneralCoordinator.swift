//
//  GeneralCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

final class GeneralCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override func start() {
        showMain()
    }

    override func close(animated: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func showMain() {
        let viewController = MainAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
