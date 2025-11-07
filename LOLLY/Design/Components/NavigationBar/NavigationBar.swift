//
//  NavigationBar.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 28.10.2025.
//

private import SnapKit
import UIKit

public final class NavigationBar: BaseNavigationBar {
    // MARK: - Public Properties

    public var isHiddenRightButton: Bool {
        get {
            rightButton.isHidden
        }
        set {
            rightButton.isHidden = newValue
        }
    }

    public var isEnabledRightButton: Bool {
        get {
            rightButton.isEnabled
        }
        set {
            rightButton.isEnabled = newValue
        }
    }

    public var isEnabledBackButton: Bool {
        get {
            backButton.isEnabled
        }
        set {
            backButton.isEnabled = newValue
        }
    }

    public var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            setNeedsLayout()
        }
    }

    public weak var delegate: NavigationBarDelegate?

    public var prefersCloseButton: Bool = false {
        didSet {
            setupCloseButton()
        }
    }

    public var prefersBackCloseButton: Bool = false {
        didSet {
            setupBackCloseButton()
        }
    }

    public var isBackButtonHidden: Bool = false {
        didSet {
            backButton.isHidden = isBackButtonHidden
        }
    }

    // MARK: - Private Properties

    private var backButtonHeightConstraint: Constraint?
    private var backButtonWidthConstraint: Constraint?
    private var rightButtonHeightConstraint: Constraint?
    private var rightButtonWidthConstraint: Constraint?

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Text.primary.color
        button.isHidden = true
        button.titleLabel?.font = Fonts.TTTravels.medium.font(size: 18)
        button.setTitleColor(Colors.Text.primary.color, for: .normal)
        button.setTitleColor(Colors.Controls.disabled.color, for: .disabled)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = Fonts.TTTravels.medium.font(size: 18)
        label.textColor = Colors.Text.primary.color
        label.backgroundColor = .clear
        label.text = ""
        return label
    }()

    // MARK: - Lifecycle

    override public init() {
        super.init()
        addSubviews()
        setupConstraints()
        configure()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) { nil }

    // MARK: - Internal Methods

    override func updateContentConstraints(newValue: CGFloat) {
        super.updateContentConstraints(newValue: newValue)
        backButtonHeightConstraint?.update(offset: newValue)
        backButtonWidthConstraint?.update(offset: newValue)
        rightButtonHeightConstraint?.update(offset: newValue)
        rightButtonWidthConstraint?.update(offset: newValue)
    }

    // MARK: - Public Methods

    /// Добавляет кнопку справа от заголовка, если свойство `prefersCloseButton` не установлено
    public func addRightButton(iconImage: UIImage, actionHandler: @escaping () -> Void) {
        guard prefersCloseButton == false else { return }

        setRightButton(image: iconImage)
        rightButton.isHidden = false
        rightButton.addActionHandler(actionHandler, for: .touchUpInside)
    }

    /// Добавляет кнопку справа от заголовка, если свойство `prefersCloseButton` не установлено
    public func addRightButton(title: String, actionHandler: @escaping () -> Void) {
        guard prefersCloseButton == false else { return }

        rightButton.setTitle(title, for: [])
        rightButton.isHidden = false
        rightButton.addActionHandler(actionHandler, for: .touchUpInside)
        setNeedsLayout()
    }

    public func setRightButton(image: UIImage?) {
        rightButton.setImage(image, for: [])
    }
}

// MARK: - Private Methods

extension NavigationBar {
    fileprivate func addSubviews() {
        contentView.addSubview(backButton)
        contentView.addSubview(rightButton)
        contentView.addSubview(titleLabel)
    }

    fileprivate func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide.snp.leading)
            make.centerY.equalTo(contentView.layoutMarginsGuide.snp.centerY)
            backButtonHeightConstraint = make.height.equalTo(contentSize).constraint
            backButtonWidthConstraint = make.width.equalTo(contentSize).constraint
        }

        rightButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
            make.centerY.equalTo(contentView.layoutMarginsGuide.snp.centerY)
            rightButtonHeightConstraint = make.height.equalTo(contentSize).constraint
            rightButtonWidthConstraint = make.width.greaterThanOrEqualTo(contentSize).constraint
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.trailing.lessThanOrEqualTo(rightButton.snp.leading)
            make.centerX.equalTo(contentView.layoutMarginsGuide.snp.centerX)
            make.centerY.equalTo(contentView.layoutMarginsGuide.snp.centerY)
        }
    }

    fileprivate func configure() {
        setupBackButton()
    }

    fileprivate func setupBackButton() {
        // Replace AppResources with your assets accessor if needed.
        backButton.setImage(
            Assets.Controls.backArrow.image.withRenderingMode(.alwaysTemplate),
            for: []
        )
        backButton.tintColor = Colors.Text.primary.color
    }

    fileprivate func setupCloseButton() {
        guard prefersCloseButton else {
            backButton.isHidden = false
            rightButton.isHidden = true
            return
        }

        let closeIconImage = Assets.Controls.close.image.withRenderingMode(.alwaysTemplate)
        backButton.isHidden = true
        rightButton.isHidden = false
        rightButton.addActionHandler({ [weak self] in
            self?.handleCloseTap()
        }, for: .touchUpInside)
        setRightButton(image: closeIconImage)
    }

    fileprivate func setupBackCloseButton() {
        guard prefersBackCloseButton else {
            setupBackButton()
            return
        }

        let closeIconImage = Assets.Controls.close.image.withRenderingMode(.alwaysTemplate)
        backButton.isHidden = false
        backButton.setImage(closeIconImage, for: [])
    }

    @objc
    fileprivate func handleBackTap() {
        delegate?.didReceiveBackAction(self)
    }

    fileprivate func handleCloseTap() {
        delegate?.didReceiveCloseAction(self)
    }
}
