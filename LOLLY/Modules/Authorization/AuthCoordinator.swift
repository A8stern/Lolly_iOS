//
//  AuthCoordinator.swift
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

    override func close(animated _: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func openAuthMethods() {
        let viewController = AuthMethodsAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func openPhoneLogIn() {
        let viewController = PhoneLogInAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func openCode(phone: String) {
        let viewController = OtpCodeAssembly.instance().assembleModule(coordinator: self, phone: phone)
        navigationController.pushViewController(viewController, animated: true)
    }
}
