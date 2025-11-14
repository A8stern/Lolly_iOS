//
//  SnackView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 14.11.2025.
//

import SwiftMessages
import UIKit

public final class SnackView: BaseView {
    // MARK: - Nested

    public enum SnackProps {
        case error(icon: UIImage? = nil, text: String)
        case warning(icon: UIImage? = nil, text: String)
        case success(icon: UIImage? = nil, text: String)
    }

    // MARK: - Views

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Styles.caption
        label.textColor = Colors.Notification.text.color
        label.numberOfLines = 0
        return label
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Lifecycle

    init(props: SnackProps) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        configureMessage(props: props)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension SnackView {
    func addSubviews() {
        installBackgroundView(contentView, insets: .init(top: .zero, left: 16.0, bottom: .zero, right: 16.0))
        contentView.addSubview(iconView)
        contentView.addSubview(textLabel)
    }

    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            iconView.widthAnchor.constraint(equalToConstant: Constants.iconSize),

            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing),
            textLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.spacing),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing)
        ])
    }

    func configureMessage(props: SnackProps) {
        switch props {
            case let .error(icon, text):
                textLabel.text = text
                let iconImage = icon ?? Assets.error.image
                iconView.image = iconImage.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = Colors.Notification.error.color
                contentView.backgroundColor = Colors.Notification.background.color

            case let .warning(icon, text):
                textLabel.text = text
                let iconImage = icon ?? Assets.error.image
                iconView.image = iconImage.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = Colors.Notification.error.color
                contentView.backgroundColor = Colors.Notification.background.color

            case let .success(icon, text):
                textLabel.text = text
                let iconImage = icon ?? Assets.error.image
                iconView.image = iconImage.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = Colors.Notification.success.color
                contentView.backgroundColor = Colors.Notification.background.color
        }
    }
}

// MARK: - Consntants

private extension SnackView {
    enum Constants {
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 12
    }
}
