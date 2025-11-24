//
//  TextViewState.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

public enum TextViewState {
    /// Поля введено и корректно.
    case correct

    /// Поле некорректно.
    case invalid

    /// Поле пустое
    case empty

    /// Поле недоступно
    case disabled
}
