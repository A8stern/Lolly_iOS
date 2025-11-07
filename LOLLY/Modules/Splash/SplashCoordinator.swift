//
//  SplashCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

public final class SplashCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override public func start() {
        showSplashScreen()
    }

    override public func close(animated _: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    public func showSplashScreen() {
        let viewController = SplashAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}
