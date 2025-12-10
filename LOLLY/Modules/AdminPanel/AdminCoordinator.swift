//
//  AdminCoordinator.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

import UIKit

final class AdminCoordinator: BaseNavigationCoordinator, SystemBrowserRoute {
    // MARK: - Private Properties

    private let serviceAssembly: ServiceAssembly
    private let phone: String

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        serviceAssembly: ServiceAssembly,
        phone: String
    ) {
        self.serviceAssembly = serviceAssembly
        self.phone = phone
        super.init(navigationController: navigationController)
    }

    override func start() {
        showAdminPanel()
    }

    override func close(animated _: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    func showAdminPanel() {
        let viewController = MainAdminAssembly.instance().assembleModule(coordinator: self, phone: phone)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPush() {
        let viewController = PushNotifyAssembly.instance().assembleModule(coordinator: self)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }

    func showQRCodeScanner() {
        let viewController = QRScanAssembly.instance().assembleModule(
            coordinator: self,
            serviceAssembly: serviceAssembly
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPhotoPermission() {
        let viewController = PhotoPermissionAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAdminLoading() {
        let viewController = LoyaltyLoadingAssembly.instance().assembleAdminModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func closePush() {
        navigationController.dismiss(animated: true)
    }
}
