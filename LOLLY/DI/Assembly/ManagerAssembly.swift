//
//  ManagerAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 05.11.2025.
//

public final class ManagerAssembly: Assembly {
    // MARK: Public Properties

    public var screenBrightnessManager: ScreenBrightnessManagerInterface {
        define(
            scope: .lazySingleton,
            init: ScreenBrightnessManager()
        )
    }
}
