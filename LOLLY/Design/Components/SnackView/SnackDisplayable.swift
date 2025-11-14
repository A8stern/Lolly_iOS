//
//  SnackDisplayable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 14.11.2025.
//

import SwiftMessages
import UIKit

// MARK: - SnackDisplayable

public protocol SnackDisplayable: AnyObject {
    func showSnack(with props: SnackView.SnackProps)
    func enqueueMessage(with props: SnackView.SnackProps)
}

public extension SnackDisplayable {
    // MARK: - Public Methods

    @MainActor
    func showSnack(with props: SnackView.SnackProps) {
        guard SwiftMessages.sharedInstance.current() == nil else {
            return
        }
        showSnack(props: props)
    }

    @MainActor
    func enqueueMessage(with props: SnackView.SnackProps) {
        showSnack(props: props)
    }

    @MainActor
    func hideCurrentMessage() {
        guard SwiftMessages.sharedInstance.current() != nil else {
            return
        }
        SwiftMessages.hide(animated: true)
    }

    // MARK: - Private Methods

    @MainActor
    private func showSnack(props: SnackView.SnackProps) {
        let view = SnackView(props: props)
        var config = SwiftMessages.Config()
        config.dimMode = .none
        config.duration = .seconds(seconds: 4)
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: .normal)
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }
}

// MARK: - UIViewController

extension UIViewController: @MainActor SnackDisplayable { }
