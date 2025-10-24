//
//  HapticManagerInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

public protocol HapticManagerInterface {
    var isHapticAvailable: Bool { get }

    func play(type: HapticType)
}
