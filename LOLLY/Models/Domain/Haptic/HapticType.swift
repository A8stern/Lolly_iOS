//
//  HapticType.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

public enum HapticType {
//    /// Haptic-паттерн «дыхания» на Launch'е приложения
//    case outro

    /// Короткий тактильный отклик
    case sensoryFeedback(style: HapticSensoryFeedbackStyle)
}
