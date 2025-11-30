//
//  AppTheme.swift
//  LOLLY
//
//  Created by Auto on 15.11.2025.
//

import UIKit

public enum AppTheme: Int, CaseIterable {
    case device = 0
    case light = 1
    case dark = 2

    public var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
            case .device:
                return .unspecified

            case .light:
                return .light

            case .dark:
                return .dark
        }
    }

    public var displayName: String {
        switch self {
            case .device:
                return "Системная"

            case .light:
                return "Светлая"

            case .dark:
                return "Темная"
        }
    }
}
