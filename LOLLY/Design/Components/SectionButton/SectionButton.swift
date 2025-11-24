//
//  SectionButton.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

private import SnapKit
import UIKit

public final class SectionButton: UIButton, ViewModellable {
    public typealias ViewModel = SectionButtonViewModel?

    public var viewModel: ViewModel {
        didSet { updateUI() }
    }

    // MARK: UI

    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Styles.custom(weight: .regular, size: 17)
        label.textColor = .label
        return label
    }()

    private lazy var bottomSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Text.secondary.color.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var rightStaticImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = Colors.Text.secondary.color
        return imageView
    }()

    // MARK: Initializers

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateUI()
    }
}

// MARK: - ViewConfigurable

extension SectionButton {
    public func setupLayout() {
        addSubview(leftImageView)
        addSubview(leftLabel)
        addSubview(rightStaticImageView)
        addSubview(bottomSeparatorLineView)

        snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        leftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Constants.iconSize)
            make.left.equalToSuperview()
        }

        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(rightStaticImageView.snp.left).offset(-12)
        }

        rightStaticImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(18)
            make.right.equalToSuperview()
        }

        bottomSeparatorLineView.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }

    public func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true

        updateUI()
    }

    public func setupBehaviour() {
        addTapActionHandler { [weak self] in
            guard let self else { return }
            self.viewModel?.tapHandler?()
        }
    }

    public func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else {
            bottomSeparatorLineView.isHidden = true
            return
        }

        leftImageView.image = viewModel.iconAsset.image
        leftLabel.text = viewModel.text

        bottomSeparatorLineView.backgroundColor = Colors.Text.secondary.color.withAlphaComponent(0.5)
    }
}

// MARK: - Constants

extension SectionButton {
    fileprivate enum Constants {
        static let iconSize: CGFloat = 29
    }
}
