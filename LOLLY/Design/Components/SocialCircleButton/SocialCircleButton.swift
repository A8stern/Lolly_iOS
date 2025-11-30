//
//  SocialCircleButton.swift
//  LOLLY
//
//  Created by Nikita on 11.11.2025.
//

import Kingfisher
private import SnapKit
import UIKit

// swiftlint:disable:next uibutton_unavailable
public final class SocialCircleButton: UIButton, ViewModellable {
    public typealias ViewModel = SocialCircleButtonViewModel?

    // MARK: - ViewModellable

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    // MARK: - Initializers

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("CircleIconButton ::: init?(coder:) is not supported")
    }

    // MARK: - Lifecycle

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateUI()
    }

    // MARK: - Private helpers

    private func makeRounded() {
        layer.cornerRadius = Constants.size / 2
        layer.masksToBounds = true
    }

    private func applyIcon(_ viewModel: ViewModel) {
        guard let url = viewModel?.iconURL else { return }

        let downloader = ImageDownloader.default
        downloader.downloadImage(with: url) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let value):
                    let icon = value.image.withRenderingMode(.alwaysTemplate)
                    setImage(icon, for: [])

                case .failure:
                    let placeholder = UIImage(systemName: "link")
                    setImage(placeholder, for: [])
            }
        }

        imageView?.tintColor = Constants.iconTint.color
    }

    private func applyColors() {
        if !isEnabled {
            backgroundColor = Constants.disabled.color
            return
        }

        backgroundColor =
        isHighlighted
        ? Constants.pressed.color
        : Constants.background.color
    }

    private func updateSize() {
        snp.remakeConstraints { make in
            make.size.equalTo(Constants.size)
        }
    }
}

// MARK: - ViewConfigurable

extension SocialCircleButton {
    public func setupLayout() {
        contentEdgeInsets = SocialCircleButton.contentInsets
    }

    public func setupUI() {
        makeRounded()
        updateUI()
    }

    public func setupBehaviour() {
        addTarget(
            self,
            action: #selector(didTap),
            for: .touchUpInside
        )
    }

    @objc
    private func didTap() {
        viewModel?.tapHandler?()
    }

    public func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }

        updateSize()
        makeRounded()
        applyIcon(viewModel)
        applyColors()
    }
}

// MARK: - Contentable

extension SocialCircleButton: Contentable {
    public static var contentInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: Constants.padding,
            left: Constants.padding,
            bottom: Constants.padding,
            right: Constants.padding
        )
    }

    private enum Constants {
        static let size: CGFloat = 52
        static let padding: CGFloat = 12

        static let background = Colors.Controls.secondary
        static let pressed = Colors.Controls.secondaryPressed
        static let disabled = Colors.Controls.disabled

        static let iconTint = Colors.Constants.white
    }
}
