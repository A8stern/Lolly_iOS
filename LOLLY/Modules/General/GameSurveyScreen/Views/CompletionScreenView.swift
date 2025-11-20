//
//  CompletionScreenView.swift
//  LOLLY
//
//  Created by Егор on 08.11.2025.
//

import Kingfisher
private import SnapKit
import UIKit

public final class CompletionScreenView: UIView {
    // MARK: - Private Properties

    private lazy var circleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Constants.grey.color.withAlphaComponent(0.1)
        return view
    }()

    private lazy var drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var congratulationsLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Gamification.congratulation
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.Styles.custom(weight: .bold, size: 32)
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Gamification.gameEnd
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.Styles.title2
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    // MARK: - Initialization

    public init() {
        super.init(frame: .zero)

        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    public func configure(title: String, description: String, imageURL: URL?) {
        congratulationsLabel.text = title
        descriptionLabel.text = description
        drinkImageView.kf.setImage(with: imageURL)
    }
}

// MARK: - Setup

extension CompletionScreenView {
    fileprivate func setupLayout() {
        addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.circleSize)
        }

        circleBackgroundView.addSubview(drinkImageView)
        drinkImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        circleBackgroundView.addSubview(congratulationsLabel)
        congratulationsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.congratulationsOffsetFromCenter)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        circleBackgroundView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(congratulationsLabel.snp.bottom).offset(Constants.descriptionTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }
    }

    fileprivate func setupUI() {
        backgroundColor = Colors.Custom.inverted.color

        circleBackgroundView.layer.cornerRadius = Constants.circleSize / 2
        circleBackgroundView.clipsToBounds = true
    }
}

// MARK: - Constants

extension CompletionScreenView {
    fileprivate enum Constants {
        static let circleSize: CGFloat = 300
        static let congratulationsOffsetFromCenter: CGFloat = -20
        static let descriptionTopOffset: CGFloat = 16
        static let horizontalInset: CGFloat = 24
    }
}
