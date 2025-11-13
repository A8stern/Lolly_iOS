//
//  SocialCircleButton.swift
//  LOLLY
//
//  Created by Nikita on 11.11.2025.
//

private import SnapKit
import UIKit

import Kingfisher

public final class SocialCircleButton: UIButton, ViewModellable {
    public typealias ViewModel = SocialCircleButtonViewModel?

    public var viewModel: ViewModel {
        didSet { updateUI() }
    }

    // MARK: UI

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Colors.Controls.inactive)
        view.layer.cornerRadius = (Constants.buttonDiameter - 2) / 2
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false

        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false

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

extension SocialCircleButton {
    public func setupLayout() {
        addSubview(iconContainerView)
        iconContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.buttonDiameter - 2)
        }

        iconContainerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.iconSize)
        }
    }

    public func setupUI() {
        layer.cornerRadius = Constants.buttonDiameter / 2
        layer.masksToBounds = true

        updateUI()
    }

    public func setupBehaviour() {
        addTapActionHandler { [weak self] in
            guard let self else { return }
            viewModel?.tapHandler?()
        }
    }

    public func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }
        iconImageView.kf.setImage(
            with: URL(string: viewModel.iconURL),
            placeholder: UIImage(systemName: "link")
        )
    }
}

// MARK: - Constants

extension SocialCircleButton {
    fileprivate enum Constants {
        static let buttonDiameter: CGFloat = 52
        static let iconSize: CGFloat = 20
    }
}
