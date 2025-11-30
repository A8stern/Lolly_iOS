//
//  GeneralCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

final class GeneralCoordinator: BaseNavigationCoordinator, SystemBrowserRoute {
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
        showMain()
    }

    override func close(animated _: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func showMain() {
        let viewController = MainAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showGameSurvey() {
        let viewController = GameSurveyAssembly.instance().assembleModule(
            coordinator: self,
            serviceAssembly: serviceAssembly
        )
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }

    func closeGameSurvey() {
        navigationController.dismiss(animated: true)
    }

    func showScanner() {
        let viewController = ScannerAssembly.instance().assembleModule(coordinator: self)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }

    func closeScanner() {
        navigationController.dismiss(animated: true)
    }

    func showLoading() {
        let viewController = LoyaltyLoadingAssembly.instance().assembleModule(coordinator: self)
        viewController.modalPresentationStyle = .fullScreen

        let presenter = topMostPresenter(from: navigationController)
        presenter.present(viewController, animated: true)
    }

    func closeLoading() {
        navigationController.dismiss(animated: true)
    }

    func showProfile() {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
        coordinator.onCompleted = { [coordinator, weak self] in
            self?.remove(child: coordinator)
        }
    }
}

extension GeneralCoordinator {
    fileprivate func topMostPresenter(from base: UIViewController) -> UIViewController {
        var top = base
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
