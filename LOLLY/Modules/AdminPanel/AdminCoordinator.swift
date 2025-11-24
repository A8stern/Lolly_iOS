//
//  AdminCoordinator.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

internal import UIKit

final class AdminCoordinator: BaseNavigationCoordinator, SystemBrowserRoute {
    // MARK: - Private Properties

    private let serviceAssembly: ServiceAssembly

    // MARK: - Lifecycle
    init(
        navigationController: UINavigationController,
        serviceAssembly: ServiceAssembly
    ) {
        self.serviceAssembly = serviceAssembly
        super.init(navigationController: navigationController)
    }

    override func start() {
        showAdminPanel()
    }

    override func close(animated _: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    func showAdminPanel() {
        let session = URLSession.shared
        let networkService = NetworkService(session: session)
        let viewController = MainAdminAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPush() {
        let viewController = PushNotifyAssembly.instance().assembleModule(coordinator: self)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }

    func closePush() {
        navigationController.dismiss(animated: true)
    }
}
