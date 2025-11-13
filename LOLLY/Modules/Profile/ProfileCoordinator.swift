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

    // MARK: - Lifecycle

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
}
