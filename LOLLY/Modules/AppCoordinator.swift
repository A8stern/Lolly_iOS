//
//  AppCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

public import UIKit

public final class AppCoordinator: BaseCoordinator<UIWindow> {
    // MARK: - Public Properties

    public var window: UIWindow {
        root as UIWindow
    }

    public var sessionUseCase: SessionUseCaseInterface

    // MARK: - Private Properties

    private let serviceAssembly = ServiceAssembly.instance()
    private let useCaseAssembly = UseCaseAssembly.instance()

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        sessionUseCase = useCaseAssembly.sessionUseCase
        super.init(root: window)
    }

    // MARK: - Public Methods

    override public func start() {
        sessionUseCase.delegate = self
        showSplashScreen()
    }

    override public func add(child coordinator: any Coordinator) {
        super.add(child: coordinator)
        switch coordinator.root {
            case let viewController as UIViewController:
                window.rootViewController = viewController

                if window.isKeyWindow == false {
                    window.makeKeyAndVisible()
                }

            default:
                break
        }
    }

    override public func coordinatorDidClose(_ coordinator: some Coordinator) {
        super.coordinatorDidClose(coordinator)

        switch coordinator {
            case is AuthCoordinator:
                goToGeneralFlow()

            case is GeneralCoordinator, is AdminCoordinator:
                goToAuthFlow()

            case is SplashCoordinator:
                setupFlow()

            default:
                break
        }
    }

    // MARK: - Flows

    public func showSplashScreen() {
        let navigationController = UINavigationController()
        let coordinator = SplashCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
    }

    public func setupFlow() {
        let isAuthorized = sessionUseCase.isAuthorized
        isAuthorized ? goToGeneralFlow() : goToAuthFlow()
    }

    public func goToAuthFlow() {
        let navigationController = UINavigationController()
        let coordinator = AuthCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
    }

    public func goToGeneralFlow() {
        let navigationController = UINavigationController()
        let coordinator = GeneralCoordinator(
            navigationController: navigationController,
            serviceAssembly: serviceAssembly
        )
        add(child: coordinator)
        coordinator.start()
    }

    public func goToAdminFlow() {
        let navigationController = UINavigationController()
        let coordinator = AdminCoordinator(
            navigationController: navigationController,
            serviceAssembly: serviceAssembly
        )
        add(child: coordinator)
        coordinator.start()
    }
}

// MARK: - SessionUseCaseDelegate

extension AppCoordinator: SessionUseCaseDelegate {
    public func sessionUseCaseDidSignOut() {
        // Закрываем основной координатор авторизованной зоны
        guard let coordinator = children.last as? GeneralCoordinator else {
            return
        }

        coordinator.close(animated: true)
    }
}
