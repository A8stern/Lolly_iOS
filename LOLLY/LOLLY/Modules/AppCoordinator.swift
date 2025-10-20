//
//  RootCoordinator.swift
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

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        super.init(root: window)
    }

    // MARK: - Public Methods

    override public func start() {
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
//            case is OnboardingCoordinator:
//                goToGeneralFlow()

            case is GeneralCoordinator:
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
        // TODO: Вынести в UseCase / Manager
        let isAuthorized = true

        isAuthorized ? goToGeneralFlow() : goToAuthFlow()
    }

    public func goToAuthFlow() { }

    public func goToGeneralFlow() {
        let navigationController = UINavigationController()
        let coordinator = GeneralCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
    }
}
