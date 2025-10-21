//
//  SceneDelegate.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    // MARK: - Internal Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }
}
