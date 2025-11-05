//
//  ScreenBrightnessManagerInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 05.11.2025.
//

public protocol ScreenBrightnessManagerInterface {
    func set(to mode: BrightnessMode)
    func restore()
}
