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

private extension QuestionOptionButton {
    func setupUI(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.TTTravels.medium.font(size: 16)
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
            outgoing.font = Fonts.TTTravels.medium.font(size: 16)
            return outgoing
        }

        configuration = config
    }

    func setupBehaviour() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc
    func handleTap() {
        onTap?()
    }
}

// MARK: - Constants

private extension QuestionOptionButton {
    enum Constants {
        static let verticalPadding: CGFloat = 16.0
        static let horizontalPadding: CGFloat = 24.0
    }
}
