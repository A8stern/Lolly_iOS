//
//  DigitCellView.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

import UIKit

final class DigitCellView: UIView {
    let label = UILabel()

    var isActive: Bool = false { didSet { updateAppearance() } }
    var isFilled: Bool { label.text?.isEmpty == false }

    var cornerRadius: CGFloat = 12 { didSet { layer.cornerRadius = cornerRadius } }
    var borderWidth: CGFloat = 1 { didSet { layer.borderWidth = borderWidth } }
    var activeBorderColor: UIColor = .label
    var inactiveBorderColor: UIColor = .separator
    var fillColor: UIColor = .systemGray6 {
        didSet { backgroundColor = fillColor }
    }

    var textColor: UIColor = .label
    var font: UIFont = .systemFont(ofSize: 28, weight: .regular) { didSet { label.font = font } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        backgroundColor = fillColor

        label.textAlignment = .center
        label.font = font
        label.textColor = textColor

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func updateAppearance() {
        layer.borderColor = (isActive ? activeBorderColor : inactiveBorderColor).cgColor
        backgroundColor = fillColor // ВСЕГДА выставляем fillColor!
    }
}
