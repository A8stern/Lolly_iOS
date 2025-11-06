//
//  ScreenBrightnessManager.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 05.11.2025.
//

import UIKit

public enum BrightnessMode {
    case full
    case custom(CGFloat)
}

public final class ScreenBrightnessManager: ScreenBrightnessManagerInterface {
    private var previousBrightness: CGFloat?
    private var isOverridden: Bool = false

    public init() { }

    public func set(to mode: BrightnessMode) {
        guard !isOverridden else { return }
        previousBrightness = UIScreen.main.brightness
        switch mode {
            case .full:
                UIScreen.main.brightness = 1.0

            case .custom(let value):
                UIScreen.main.brightness = min(max(value, 0.0), 1.0)
        }

        isOverridden = true
    }

    public func restore() {
        guard isOverridden, let previous = previousBrightness else { return }
        UIScreen.main.brightness = previous
        previousBrightness = nil
        isOverridden = false
    }
}
