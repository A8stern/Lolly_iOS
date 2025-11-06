//
//  TextFieldState.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

public enum TextFieldState {
    /// Поля введено и корректно.
    case correct

    /// Поле некорректно.
    case invalid

    /// Поле пустое
    case empty

    /// Поле недоступно
    case disabled
}
