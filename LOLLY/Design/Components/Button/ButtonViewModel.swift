//
//  ButtonViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

public struct ButtonViewModel: Changeable {
    public struct Config {
        let icon: Icon?
        let imageTintColor: ColorAsset
        let contentColor: ColorAsset
        let enabledColor: ColorAsset
        let pressedColor: ColorAsset
        let disabledColor: ColorAsset
        let needImageTint: Bool

        public init(
            icon: Icon?,
            imageTintColor: ColorAsset,
            contentColor: ColorAsset,
            enabledColor: ColorAsset,
            pressedColor: ColorAsset,
            disabledColor: ColorAsset,
            needImageTint: Bool
        ) {
            self.icon = icon
            self.imageTintColor = imageTintColor
            self.contentColor = contentColor
            self.enabledColor = enabledColor
            self.pressedColor = pressedColor
            self.disabledColor = disabledColor
            self.needImageTint = needImageTint
        }
    }

    public enum `Type` {
        /// Основная закрашенная кнопка
        case primary(Icon?)

        /// Вспомогательная закрашенная кнопка
        case secondary(Icon?)

        /// Кастомная кнопка
        case custom(Config)
    }

    public enum Size {
        /// Высота 52
        case large
    }

    public enum Icon {
        /// Иконка слева
        case left(icon: ImageAsset)
    }

    public var title: String?
    public let type: `Type`
    public let size: Size
    public var tapHandler: (() -> Void)?

    public init(
        title: String? = nil,
        type: Type = .primary(.none),
        size: Size = .large,
        tapHandler: (() -> Void)? = nil
    ) {
        self.title = title
        self.type = type
        self.size = size
        self.tapHandler = tapHandler
    }
}
