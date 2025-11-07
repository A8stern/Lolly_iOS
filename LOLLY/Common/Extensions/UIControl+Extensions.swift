//
//  UIControl+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 28.10.2025.
//

import ObjectiveC
import UIKit

extension UIControl {
    @objc
    public func addActionHandler(_ handler: @escaping () -> Void, for event: UIControl.Event) {
        removeTarget(self, action: #selector(handleAction), for: event)
        addTarget(self, action: #selector(handleAction), for: event)
        actionHandler = handler
    }
}

extension UIControl {
    fileprivate enum AssociatedKeys {
        static var actionHandlerKey: Int = 0
    }

    fileprivate var actionHandler: (() -> Void)? {
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
    fileprivate func handleAction() {
        actionHandler?()
    }
}
