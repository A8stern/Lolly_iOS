//
//  CircleButton.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 05.11.2025.
//

private import SnapKit
import UIKit

// swiftlint:disable:next uibutton_unavailable
public final class CircleButton: UIButton, ViewModellable {
    public typealias ViewModel = CircleButtonViewModel?

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

    // MARK: - UI

    private lazy var innerCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(asset: Colors.accentColor)
        view.layer.cornerRadius = (Constants.diameter - 2) / 2
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false

        return view
    }()

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false

        return imageView
    }()

    // MARK: - Initializers

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel
        super.init(frame: .zero)

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

extension CircleButton {
    public func setupLayout() {
        addSubview(innerCircleView)
        innerCircleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.diameter - 2)
        }
        innerCircleView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }

    public func setupUI() {
        backgroundColor = Colors.secondaryColor.color
        layer.cornerRadius = Constants.diameter / 2
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

        iconView.image = viewModel.type.image
    }
}

// MARK: - Contentable

extension CircleButton: Contentable {
    public static let contentInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
}

// MARK: - Constants

extension CircleButton {
    private enum Constants {
        static let diameter: CGFloat = 50
    }
}
