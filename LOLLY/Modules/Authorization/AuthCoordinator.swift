//
//  GeneralCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

internal import UIKit

final class AuthCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override func start() {
        openAuthMethods()
    }

    override func close(animated: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func openAuthMethods() {
        let viewController = AuthMethodsAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func openPhoneAuth() { }
}
