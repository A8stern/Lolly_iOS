//
//  Button.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.10.2025.
//

private import SnapKit
import UIKit

// swiftlint:disable:next uibutton_unavailable
public final class Button: UIButton, ViewModellable {
    public typealias ViewModel = ButtonViewModel?

    private enum Constants {
        static let imagePadding: CGFloat = 5.0
        static let imagePaddingCompact: CGFloat = 2.0
    }

    // MARK: - ViewModellable properties

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    // MARK: - Public properties

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        // NOTE: UIButton некорректно высчитывает ширину при наличии инсетов между картинкой и лейблом и дополнительном
        // инстете по краям контента. Эта проблема решена с использованием UIButton.Configuration для версий iOS 15 и
        // выше, однако требует значительного изменения кода и поддержки обратной совместимости с версиями ниже
        return CGSize(
            width: size.width + titleEdgeInsets.left + titleEdgeInsets.right,
            height: size.height
        )
    }

    override public var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI

    private var heightConstraint: Constraint?

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
        fatalError("Button ::: required init?(coder: NSCoder)")
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateUI()
    }

    // MARK: - Private functions

    @objc
    private func didTapButton() {
        viewModel?.tapHandler?()
    }

    private func makeCorners() {
        guard let height = viewModel?.size.height else { return }

        layer.cornerRadius = height / 2
        layer.masksToBounds = true
    }

    private func setupTitle(with viewModel: ButtonViewModel) {
        titleLabel?.font = viewModel.font

        if let title = viewModel.title {
            setTitle(title, for: .normal)
        }

        setTitleColor(viewModel.contentColor.color, for: .normal)
        setTitleColor(Colors.Constants.grey.color, for: .disabled)
    }

    private func setupColors(with viewModel: ButtonViewModel) {
        if isEnabled {
            backgroundColor =
                isHighlighted
                    ? viewModel.pressedBackgroundColorAsset.color : viewModel.enabledBackgroundColorAsset.color
        } else {
            backgroundColor = viewModel.disabledColor.color
        }
    }

    private func setupIcon(with viewModel: ButtonViewModel) {
        switch viewModel.icon {
            case .left(let icon):
                let image = {
                    guard viewModel.needImageTint else {
                        return UIImage(asset: icon)
                    }
                    return UIImage(asset: icon)?.withRenderingMode(.alwaysTemplate)
                }()
                let imagePadding = {
                    switch viewModel.size {
                        case .large:
                            return Constants.imagePadding

                        case .medium:
                            return Constants.imagePadding
                    }
                }()
                setImage(image, for: .normal)
                semanticContentAttribute = .forceLeftToRight
                contentEdgeInsets = makeEdgeInsets(
                    left: viewModel.size.contentHorizontalInset + imagePadding,
                    right: viewModel.size.contentHorizontalInset + imagePadding
                )
                imageEdgeInsets = makeEdgeInsets(left: 0, right: imagePadding)
                titleEdgeInsets = makeEdgeInsets(left: imagePadding, right: 0)

            case .none:
                setImage(nil, for: .normal)
                contentEdgeInsets = makeEdgeInsets(
                    left: viewModel.size.contentHorizontalInset,
                    right: viewModel.size.contentHorizontalInset
                )
        }
    }

    private func makeEdgeInsets(
        left: CGFloat,
        right: CGFloat
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: left,
            bottom: 0,
            right: right
        )
    }

    private func updateHeight(_ height: CGFloat) {
        heightConstraint?.deactivate()
        snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(height).constraint
        }
    }
}

// MARK: - ViewConfigurable

public extension Button {
    func setupLayout() { }

    func setupUI() {
        makeCorners()
        updateUI()
    }

    func setupBehaviour() {
        addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
    }

    func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }

        updateHeight(viewModel.size.height)
        makeCorners()

        setupTitle(with: viewModel)
        setupColors(with: viewModel)

        if viewModel.needImageTint {
            let imageViewColor =
                isEnabled
                    ? viewModel.imageTintColor
                    : Colors.Constants.grey

            let updatedImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
            imageView?.tintColor = imageViewColor.color
            setImage(updatedImage, for: .normal)
        }

        setupIcon(with: viewModel)
    }
}

// MARK: - Contentable

extension Button: Contentable {
    public static let contentInsets = UIEdgeInsets(top: 8, left: 20, bottom: 20, right: 8)
}

// MARK: - ButtonViewModel extensions

extension ButtonViewModel.Size {
    var height: CGFloat {
        switch self {
            case .large:
                return 52

            case .medium:
                return 34
        }
    }

    var contentHorizontalInset: CGFloat {
        switch self {
            case .large:
                return 24

            case .medium:
                return 14
        }
    }
}

// MARK: - ButtonViewModel extensions

fileprivate extension ButtonViewModel {
    var font: UIFont {
        switch size {
            case .large:
                return Fonts.TTTravels.demiBold.font(size: 16)

            case .medium:
                return Fonts.TTTravels.medium.font(size: 12)
        }
    }

    var icon: ButtonViewModel.Icon? {
        switch type {
            case .primary(let option),
                 .secondary(let option):
                return option

            case .custom(let config):
                return config.icon
        }
    }

    var imageTintColor: ColorAsset {
        switch type {
            case .primary:
                return Colors.Constants.white

            case .secondary:
                return Colors.Text.primary

            case .custom(let config):
                return config.imageTintColor
        }
    }

    var contentColor: ColorAsset {
        switch type {
            case .primary:
                return Colors.Constants.white

            case .secondary:
                return Colors.Text.primary

            case .custom(let config):
                return config.contentColor
        }
    }

    var enabledBackgroundColorAsset: ColorAsset {
        switch type {
            case .primary:
                return Colors.Controls.primary

            case .secondary:
                return Colors.Controls.secondary

            case .custom(let config):
                return config.enabledColor
        }
    }

    var pressedBackgroundColorAsset: ColorAsset {
        switch type {
            case .primary:
                return Colors.Controls.primaryPressed

            case .secondary:
                return Colors.Controls.secondaryPressed

            case .custom(let config):
                return config.pressedColor
        }
    }

    var disabledColor: ColorAsset {
        switch type {
            case .primary:
                return Colors.Controls.disabled

            case .secondary:
                return Colors.Controls.secondary

            case .custom(let config):
                return config.disabledColor
        }
    }

    var needImageTint: Bool {
        switch type {
            case .primary, .secondary:
                return true

            case .custom(let config):
                return config.needImageTint
        }
    }
}
