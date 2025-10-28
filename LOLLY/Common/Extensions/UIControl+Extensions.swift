//
//  UIControl+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 28.10.2025.
//

import ObjectiveC
import UIKit

public extension UIControl {
    @objc
    func addActionHandler(_ handler: @escaping () -> Void, for event: UIControl.Event) {
        removeTarget(self, action: #selector(handleAction), for: event)
        addTarget(self, action: #selector(handleAction), for: event)
        actionHandler = handler
    }
}

private extension UIControl {
    enum AssociatedKeys {
        static var actionHandlerKey: Int = 0
    }
    var actionHandler: (() -> Void)? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.actionHandlerKey) as? (() -> Void)
        }
        set {
            guard let actionHandler = newValue else {
                return
            }
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.actionHandlerKey,
                actionHandler,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }
    @objc
    func handleAction() {
        actionHandler?()
    }
}
