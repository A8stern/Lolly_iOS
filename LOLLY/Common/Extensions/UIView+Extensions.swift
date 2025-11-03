//
//  UIView+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 03.11.2025.
//

import ObjectiveC
import UIKit

public extension UIView {
    @objc
    func addTapActionHandler(_ handler: @escaping () -> Void) {
        isUserInteractionEnabled = true
        tapActionHandler = handler

        gestureRecognizers?
            .filter { $0 is UITapGestureRecognizer && $0.name == "TapActionHandler" }
            .forEach { removeGestureRecognizer($0) }

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapAction)
        )
        tapGesture.name = "TapActionHandler"
        addGestureRecognizer(tapGesture)
    }
}

private extension UIView {
    enum AssociatedKeys {
        static var tapActionHandlerKey: UInt8 = 0
    }

    var tapActionHandler: (() -> Void)? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.tapActionHandlerKey) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.tapActionHandlerKey,
                newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }

    @objc
    func handleTapAction() {
        tapActionHandler?()
    }
}
