//
//  ContactsSectionView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 01.11.2025.
//

private import SnapKit
import UIKit

public final class ContactsSectionView: UIView, ViewModellable {
    public typealias ViewModel = ContactsSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var blurView: BlurView = {
        let view = BlurView()
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var contentStackView: StackView = {
        let stackView = StackView(axis: .vertical, space: 14)
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.font = Fonts.Styles.title3
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var topSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Text.secondary.color.withAlphaComponent(0.5)
        return view
    }()

    private lazy var addressesStackView: StackView = {
        let stackView = StackView(axis: .vertical, space: 4)
        return stackView
    }()

    private lazy var bottomSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Text.secondary.color.withAlphaComponent(0.5)
        return view
    }()

    private lazy var buttonsStackView: StackView = {
        let stackView = StackView(axis: .horizontal)
        return stackView
    }()

    private lazy var socialButtonsStackView: StackView = {
        let stackView = StackView(axis: .horizontal, space: 8)
        return stackView
    }()

    private lazy var websiteButtonsStackView: StackView = {
        let stackView = StackView(axis: .horizontal, space: 8)
        return stackView
    }()

    // MARK: - Lifecycle

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfigurable

extension ContactsSectionView {
    public func setupLayout() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(backgroundImageView.snp.width).dividedBy(Constants.imageAspectRatio)
        }

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).inset(50)
            make.left.right.bottom.equalToSuperview()
        }

        containerView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurView.contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.spacing)
        }

        contentStackView.addArrangedSubviews(
            titleLabel,
            topSeparatorLineView,
            addressesStackView,
            bottomSeparatorLineView,
            buttonsStackView
        )

        topSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }

        bottomSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }

        buttonsStackView.addArrangedSubviews(
            websiteButtonsStackView,
            UIView(),
            socialButtonsStackView
        )
    }

    public func setupUI() {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 18.0
        layer.cornerCurve = .continuous
        clipsToBounds = true

        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 18.0
        containerView.layer.cornerCurve = .continuous
        containerView.clipsToBounds = true

        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel else { return }

        if viewModel.isSkeletonable {
            displaySkeleton()
        } else {
            dismissSkeleton()
        }

        backgroundImageView.kf.setImage(with: viewModel.backgroundImageURL)
        titleLabel.text = viewModel.title
        topSeparatorLineView.isHidden = viewModel.title == nil

        addressesStackView.subviews.forEach { $0.removeFromSuperview() }
        for addressViewModel in viewModel.addresses {
            let addressView = AddressView(viewModel: addressViewModel)
            addressesStackView.addArrangedSubviews(addressView)
        }
        bottomSeparatorLineView.isHidden = viewModel.addresses.isEmpty

        socialButtonsStackView.subviews.forEach { $0.removeFromSuperview() }
        for socialButtonViewModel in viewModel.socialButtonViewModels {
            let socialButton = SocialCircleButton(viewModel: socialButtonViewModel)
            socialButtonsStackView.addArrangedSubview(socialButton)
        }

        websiteButtonsStackView.subviews.forEach { $0.removeFromSuperview() }
        for websiteButtonViewModel in viewModel.buttons {
            let websiteButton = Button(viewModel: websiteButtonViewModel)
            websiteButtonsStackView.addArrangedSubview(websiteButton)
        }
    }
}

// MARK: - SkeletonCallable

extension ContactsSectionView: SkeletonCallable {
    public func prepareForDisplaySkeleton() { }

    public func prepareForDismissSkeleton() { }
}

// MARK: - Constants

extension ContactsSectionView {
    fileprivate enum Constants {
        static let spacing: CGFloat = 21
        static let imageAspectRatio: CGFloat = 3 / 2
    }
}
