//
//  ViewContainer.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

private import SnapKit
import UIKit

/**
    Универсальный  контейнер для  определения инсетов контента по дизайн-системе.
*/
public final class ViewContainer<ContentType: Contentable>: UIView {
    public let content: ContentType

    /// - Parameters:
    ///     - block: Элемент контейнера.
    ///     - insets: Отступы внутри контейнера.
    ///     - isContentAdaptive: Параметр, игнорирующий ось, если хотя бы один отступ равен нулю.
    public init(
        block: () -> ContentType,
        insets: UIEdgeInsets,
        isContentAdaptive: Bool = false
    ) {
        self.content = block()
        super.init(frame: .zero)
        addSubview(content)

        let nonZeroInsets = [
            insets.top,
            insets.bottom,
            insets.left,
            insets.right
        ].filter { $0 != .zero }

        if isContentAdaptive, !nonZeroInsets.isEmpty {
            if insets.top != .zero || insets.bottom != .zero {
                content.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(insets.top)
                    make.bottom.equalToSuperview().inset(insets.bottom)
                    make.centerX.equalToSuperview()
                }
            }
            if insets.left != .zero || insets.right != .zero {
                content.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(insets.left)
                    make.trailing.equalToSuperview().inset(insets.right)
                    make.centerY.equalToSuperview()
                }
            }
        } else {
            content.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(insets)
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
