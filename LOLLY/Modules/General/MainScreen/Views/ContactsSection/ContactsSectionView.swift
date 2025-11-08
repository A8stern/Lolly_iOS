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
            bottomSeparatorLineView
        )

        topSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }

        bottomSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
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

        backgroundImageView.image = viewModel.backgroundImage
        titleLabel.text = viewModel.title
        topSeparatorLineView.isHidden = viewModel.title == nil

        addressesStackView.subviews.forEach { $0.removeFromSuperview() }
        for addressViewModel in viewModel.addresses {
            let addressView = AddressView(viewModel: addressViewModel)
            addressesStackView.addArrangedSubviews(addressView)
        }
        bottomSeparatorLineView.isHidden = viewModel.addresses.isEmpty
    }
}

// MARK: - Constants

extension ContactsSectionView {
    fileprivate enum Constants {
        static let spacing: CGFloat = 21
        static let imageAspectRatio: CGFloat = 3 / 2
    }
}
