//
//  ThemeManagerInterface.swift
//  LOLLY
//
//  Created by Auto on 15.11.2025.
//

public protocol ThemeManagerInterface {
    var currentTheme: AppTheme { get set }

    func applyTheme(_ theme: AppTheme)
}

