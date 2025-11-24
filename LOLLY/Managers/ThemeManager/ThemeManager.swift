//
//  ThemeManager.swift
//  LOLLY
//
//  Created by Auto on 15.11.2025.
//

import Foundation
import UIKit

public final class ThemeManager {
    public static let shared = ThemeManager()

    private let userDefaults = UserDefaults.standard
    private let themeKey = "selected_theme"

    private init() {
        applyTheme(currentTheme)
    }

    private func findActiveWindow() -> UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first { $0.isKeyWindow } ?? windowScene.windows.first
        }
        return nil
    }
}

// MARK: - ThemeManagerInterface

extension ThemeManager: ThemeManagerInterface {
    public var currentTheme: AppTheme {
        get {
            let rawValue = userDefaults.integer(forKey: themeKey)
            return AppTheme(rawValue: rawValue) ?? .device
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: themeKey)
            applyTheme(newValue)
        }
    }

    public func applyTheme(_ theme: AppTheme) {
        guard let window = findActiveWindow() else { return }
        window.overrideUserInterfaceStyle = theme.userInterfaceStyle
    }
}

