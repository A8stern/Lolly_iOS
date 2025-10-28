//
//  UIButton+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 28.10.2025.
//

import UIKit

public extension UIButton {
    @objc
    override func addActionHandler(_ handler: @escaping () -> Void, for event: UIControl.Event = .touchUpInside) {
        super.addActionHandler(handler, for: event)
    }
}
