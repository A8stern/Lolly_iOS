//
//  UIView+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 03.11.2025.
//

import ObjectiveC
import UIKit

extension UIView {
    @objc
    public func addTapActionHandler(_ handler: @escaping () -> Void) {
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

extension UIView {
    fileprivate enum AssociatedKeys {
        static var tapActionHandlerKey: UInt8 = 0
    }

    fileprivate var tapActionHandler: (() -> Void)? {
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
    fileprivate func handleTapAction() {
        tapActionHandler?()
    }
}

extension UIView {
    public func lolly_layoutIfVisible() {
        guard frame != .zero else { return }
        layoutIfNeeded()
    }
}
