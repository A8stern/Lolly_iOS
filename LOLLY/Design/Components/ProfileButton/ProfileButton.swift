//
//  ProfileButton.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

private import SnapKit
import UIKit

// swiftlint:disable:next uibutton_unavailable
public final class ProfileButton: UIButton, ViewModellable {
    public typealias ViewModel = ProfileButtonViewModel?

    // MARK: - ViewModellable properties

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    // MARK: - Public properties

    override public var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }

    // MARK: - Initializers

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel
        super.init(
            frame: .init(
                x: .zero,
                y: .zero,
                width: Constants.size,
                height: Constants.size
            )
        )

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("Button ::: required init?(coder: NSCoder)")
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateUI()
    }

    // MARK: - Private functions
}

// MARK: - ViewConfigurable

extension ProfileButton {
    public func setupLayout() {
        snp.makeConstraints {
            $0.height.width.equalTo(Constants.size)
        }

        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    public func setupUI() {
        backgroundColor = Colors.accentColor.color
        layer.cornerRadius = 6
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

        addActionHandler({
            viewModel.tapHandler?()
        }, for: .touchUpInside)

        setImage(Assets.Icons18.profile.image, for: [])
    }
}

// MARK: - Contentable

extension ProfileButton: Contentable {
    public static let contentInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
}

// MARK: - Constants

extension ProfileButton {
    private enum Constants {
        static let size: CGFloat = 24
    }
}
