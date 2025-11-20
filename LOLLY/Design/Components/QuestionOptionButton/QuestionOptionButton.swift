//
//  QuestionOptionButton.swift
//  LOLLY
//
//  Created by Егор on 08.11.2025.
//

import UIKit

public final class QuestionOptionButton: UIButton {
    // MARK: - Public Properties

    public var onTap: (() -> Void)?

    // MARK: - Initialization

    public init(title: String) {
        super.init(frame: .zero)

        setupUI(title: title)
        setupBehaviour()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

// MARK: - Setup

extension QuestionOptionButton {
    fileprivate func setupUI(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.Styles.title3
        titleLabel?.numberOfLines = 0

        clipsToBounds = true

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Colors.Constants.yellow.color
        config.baseForegroundColor = Colors.Text.primary.color
        config.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.verticalPadding,
            leading: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            trailing: Constants.horizontalPadding
        )
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = Fonts.Styles.title3
            return outgoing
        }

        configuration = config
    }

    fileprivate func setupBehaviour() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc
    fileprivate func handleTap() {
        onTap?()
    }
}

// MARK: - Constants

extension QuestionOptionButton {
    fileprivate enum Constants {
        static let verticalPadding: CGFloat = 16.0
        static let horizontalPadding: CGFloat = 24.0
    }
}
