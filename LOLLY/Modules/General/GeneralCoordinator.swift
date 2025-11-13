//
//  GeneralCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

final class GeneralCoordinator: BaseNavigationCoordinator, SystemBrowserRoute {
    // MARK: - Private Properties

    // MARK: - Lifecycle

    override func start() {
        showMain()
    }

    override func close(animated _: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func showMain() {
        let session = URLSession.shared
        let networkService = NetworkService(session: session)
        let service = MainService(networkService: networkService, isMock: false)
        let viewController = MainAssembly.instance().assembleModule(coordinator: self, mainService: service)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showGameSurvey() {
        let viewController = GameSurveyAssembly.instance().assembleModule(coordinator: self)
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

    func showProfile() {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
        coordinator.onCompleted = { [coordinator, weak self] in
            self?.remove(child: coordinator)
        }
    }
}
