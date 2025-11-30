//
//  ProfileCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

internal import UIKit

final class ProfileCoordinator: BaseNavigationCoordinator, SystemBrowserRoute {
    // MARK: - Properties

    var onCompleted: (() -> Void)?
    var onLogout: (() -> Void)?

    // MARK: - Private Properties

    private let sessionService: SessionServiceInterface

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        sessionService: SessionServiceInterface
    ) {
        self.sessionService = sessionService
        super.init(navigationController: navigationController)
    }

    override func start() {
        openProfile()
    }

    override func didClosed() {
        super.didClosed()
        onCompleted?()
    }

    // MARK: - Screens

    func openProfile() {
        let viewController = ProfileAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func logout() {
        sessionService.signOut()
        onLogout?()
    }
}
