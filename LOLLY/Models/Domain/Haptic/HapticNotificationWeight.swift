//
//  HapticNotificationWeight.swift
//  WhooshDomain
//
//  Created by Kirill Prokofyev on 28.08.2025.
//

/*
    Описание откликов
    [Playing haptics](https://developer.apple.com/design/human-interface-guidelines/playing-haptics)
*/
public enum HapticNotificationWeight {
    /// Указывает, что задача или действие успешно завершены.
    /// Ощущается как лёгкий, «прыжок» или щелчок из двух нарастающих ударов.
    case success

    /// Указывает, что задача или действие вызвали какое-либо предупреждение.
    /// Даёт краткий, прерывистый и слегка ощутимый тактильный сигнал из двух угасающих ударов.
    case warning

    /// Указывает, что произошла ошибка.
    /// Ощущается как четыре резких, отчётливых удара, привлекающих внимание.
    case error
}
