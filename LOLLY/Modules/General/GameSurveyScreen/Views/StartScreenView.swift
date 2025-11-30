//
//  StartScreenView.swift
//  LOLLY
//
//  Created by Егор on 05.11.2025.
//

import Kingfisher
private import SnapKit
import UIKit

public final class StartScreenView: UIView {
    // MARK: - Public Properties

    public var onStartTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var circleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Constants.grey.color.withAlphaComponent(0.1)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = Fonts.Styles.custom(weight: .bold, size: 32)
        label.textColor = Colors.Text.primary.color
        label.text = L10n.Gamification.start
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.Styles.custom(weight: .medium, size: 16)
        label.textColor = Colors.Text.secondary.color
        label.isHidden = true
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Assets.Controls.playButton.image, for: .normal)
        button.addTarget(self, action: #selector(onPlayTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    public init() {
        super.init(frame: .zero)

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    public func configure(
        title: String,
        subtitle: String?,
        buttonIconURL: URL?,
        backgroundImageURL _: URL?
    ) {
        titleLabel.text = title
        if let subtitle, subtitle.isEmpty == false {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }

        playButton.kf.setImage(
            with: buttonIconURL,
            for: [],
            placeholder: Assets.Controls.playButton.image
        )
    }
}

// MARK: - Setup

extension StartScreenView {
    fileprivate func setupLayout() {
        addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.circleSize)
        }

        circleBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.titleOffsetFromCenter)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        circleBackgroundView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        circleBackgroundView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.playButtonTopOffset)
            make.width.height.equalTo(Constants.playButtonSize)
        }
    }

    fileprivate func setupUI() {
        backgroundColor = Colors.Custom.inverted.color

        circleBackgroundView.layer.cornerRadius = Constants.circleSize / 2
        circleBackgroundView.clipsToBounds = true
    }

    fileprivate func setupBehaviour() { }

    @objc
    fileprivate func onPlayTap() {
        onStartTap?()
    }
}

// MARK: - Constants

extension StartScreenView {
    fileprivate enum Constants {
        static let circleSize: CGFloat = 280
        static let titleOffsetFromCenter: CGFloat = -30
        static let subtitleTopOffset: CGFloat = 8
        static let playButtonTopOffset: CGFloat = 24
        static let playButtonSize: CGFloat = 64
        static let horizontalInset: CGFloat = 24
    }
}
