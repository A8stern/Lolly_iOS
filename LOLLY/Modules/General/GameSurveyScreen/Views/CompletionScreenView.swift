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
    // MARK: - Public Properties

    public var onRestartTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var circleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Constants.grey.color.withAlphaComponent(0.1)
        return view
    }()

    private lazy var drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.08
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOffset = .zero
        return imageView
    }()

    private lazy var congratulationsLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Gamification.congratulation
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = Fonts.Styles.custom(weight: .bold, size: 24)
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Gamification.gameEnd
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.font = Fonts.Styles.body
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    private lazy var restartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Colors.Controls.primary.color
        button.layer.cornerRadius = Constants.buttonSize / 2
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = Colors.Constants.white.color
        button.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        return button
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

        if let imageURL = imageURL {
            drinkImageView.kf.setImage(
                with: imageURL,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheMemoryOnly
                ]
            )
        } else {
            drinkImageView.image = nil
        }
    }
}

// MARK: - Setup

extension CompletionScreenView {
    fileprivate func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // Круг с изображением (ниже центра экрана)
        contentView.addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.circleCenterOffset)
            make.width.height.equalTo(Constants.circleSize)
            make.top.greaterThanOrEqualToSuperview().offset(Constants.minTopInset)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.minBottomInset)
        }

        // Изображение напитка поверх круга (может выходить за границы)
        contentView.addSubview(drinkImageView)
        drinkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(circleBackgroundView.snp.centerY).offset(Constants.drinkImageVerticalOffset)
            make.leading.equalTo(circleBackgroundView.snp.leading).offset(Constants.drinkImageLeadingOffset)
            make.width.equalTo(circleBackgroundView.snp.width).multipliedBy(Constants.drinkImageWidthMultiplier)
            make.height.equalTo(circleBackgroundView.snp.height).multipliedBy(Constants.drinkImageHeightMultiplier)
        }

        // Заголовок справа от круга, наложен поверх
        contentView.addSubview(congratulationsLabel)
        congratulationsLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleBackgroundView.snp.centerX).offset(Constants.textHorizontalInset)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(circleBackgroundView.snp.top).offset(Constants.textTopOffset)
        }

        // Описание справа от круга, наложен поверх
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(congratulationsLabel)
            make.top.equalTo(congratulationsLabel.snp.bottom).offset(Constants.descriptionTopOffset)
            make.bottom.lessThanOrEqualTo(circleBackgroundView.snp.bottom).inset(Constants.descriptionBottomInset)
        }

        // Круглая кнопка повтора внутри круга
        circleBackgroundView.addSubview(restartButton)
        restartButton.snp.makeConstraints { make in
            make.centerX.equalTo(circleBackgroundView.snp.centerX).offset(Constants.buttonHorizontalOffset)
            make.bottom.equalToSuperview().inset(Constants.buttonBottomInset)
            make.width.height.equalTo(Constants.buttonSize)
        }
    }

    fileprivate func setupUI() {
        backgroundColor = Colors.Custom.inverted.color

        circleBackgroundView.layer.cornerRadius = Constants.circleSize / 2
        circleBackgroundView.clipsToBounds = false

        // Поворот изображения под небольшим углом
        drinkImageView.transform = CGAffineTransform(rotationAngle: Constants.drinkImageRotationAngle)
    }

    @objc
    fileprivate func restartButtonTapped() {
        onRestartTap?()
    }
}

// MARK: - Constants

extension CompletionScreenView {
    fileprivate enum Constants {
        static let circleSize: CGFloat = 280
        static let circleCenterOffset: CGFloat = 90
        static let minTopInset: CGFloat = 20
        static let minBottomInset: CGFloat = 20
        static let textHorizontalInset: CGFloat = 12
        static let textTopOffset: CGFloat = 32
        static let descriptionTopOffset: CGFloat = 8
        static let descriptionBottomInset: CGFloat = 40
        static let buttonSize: CGFloat = 52
        static let buttonHorizontalOffset: CGFloat = 55
        static let buttonBottomInset: CGFloat = 45
        static let horizontalInset: CGFloat = 24
        static let drinkImageWidthMultiplier: CGFloat = 0.85
        static let drinkImageHeightMultiplier: CGFloat = 1.4
        static let drinkImageLeadingOffset: CGFloat = -45
        static let drinkImageVerticalOffset: CGFloat = -20
        static let drinkImageRotationAngle: CGFloat = -15 * .pi / 180 // -15 градусов в радианах
    }
}
