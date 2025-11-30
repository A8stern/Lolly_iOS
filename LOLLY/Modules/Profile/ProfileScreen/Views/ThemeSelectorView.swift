//
//  ThemeSelectorView.swift
//  LOLLY
//
//  Created by Auto on 15.11.2025.
//

private import SnapKit
import UIKit

public final class ThemeSelectorView: UIView {
    // MARK: - Public Properties

    public var onThemeChanged: ((AppTheme) -> Void)?

    // MARK: - Private Properties

    private var selectedTheme: AppTheme = ThemeManager.shared.currentTheme

    // MARK: - Private Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тема приложения"
        label.font = Fonts.Styles.title3
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Notification.background.color
        view.layer.cornerRadius = ThemeSelectorViewConstants.containerCornerRadius
        return view
    }()

    private lazy var autoButton: ThemeOptionButton = {
        let button = ThemeOptionButton(
            theme: .device,
            isSelected: selectedTheme == .device,
            title: "Авто"
        )
        button.addTarget(self, action: #selector(autoTapped), for: .touchUpInside)
        return button
    }()

    private lazy var lightButton: ThemeOptionButton = {
        let button = ThemeOptionButton(
            theme: .light,
            isSelected: selectedTheme == .light,
            icon: UIImage(systemName: "sun.max")
        )
        button.addTarget(self, action: #selector(lightTapped), for: .touchUpInside)
        return button
    }()

    private lazy var darkButton: ThemeOptionButton = {
        let button = ThemeOptionButton(
            theme: .dark,
            isSelected: selectedTheme == .dark,
            icon: UIImage(systemName: "moon")
        )
        button.addTarget(self, action: #selector(darkTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    public init() {
        super.init(frame: .zero)

        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(ThemeSelectorViewConstants.padding)
        }

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThemeSelectorViewConstants.padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(ThemeSelectorViewConstants.spacing)
            make.bottom.equalToSuperview().inset(ThemeSelectorViewConstants.padding)
            make.height.equalTo(ThemeSelectorViewConstants.containerHeight)
        }

        containerView.addSubview(autoButton)
        autoButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(ThemeSelectorViewConstants.buttonInset)
            make.width.equalTo(containerView).dividedBy(3).offset(-ThemeSelectorViewConstants.buttonSpacing * 2 / 3)
        }

        containerView.addSubview(lightButton)
        lightButton.snp.makeConstraints { make in
            make.leading.equalTo(autoButton.snp.trailing).offset(ThemeSelectorViewConstants.buttonSpacing)
            make.top.bottom.equalToSuperview().inset(ThemeSelectorViewConstants.buttonInset)
            make.width.equalTo(autoButton)
        }

        containerView.addSubview(darkButton)
        darkButton.snp.makeConstraints { make in
            make.leading.equalTo(lightButton.snp.trailing).offset(ThemeSelectorViewConstants.buttonSpacing)
            make.trailing.top.bottom.equalToSuperview().inset(ThemeSelectorViewConstants.buttonInset)
            make.width.equalTo(autoButton)
        }
    }

    private func setupUI() {
        backgroundColor = Colors.Custom.inverted.color
        layer.cornerRadius = ThemeSelectorViewConstants.cornerRadius
        clipsToBounds = true
    }

    private func updateSelection(theme: AppTheme) {
        selectedTheme = theme
        autoButton.isSelected = theme == .device
        lightButton.isSelected = theme == .light
        darkButton.isSelected = theme == .dark
        onThemeChanged?(theme)
    }

    @objc
    private func autoTapped() {
        updateSelection(theme: .device)
    }

    @objc
    private func lightTapped() {
        updateSelection(theme: .light)
    }

    @objc
    private func darkTapped() {
        updateSelection(theme: .dark)
    }
}

// MARK: - ThemeOptionButton

private final class ThemeOptionButton: UIButton {
    private let theme: AppTheme

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            super.isSelected = newValue
            updateAppearance()
        }
    }

    init(theme: AppTheme, isSelected: Bool, title: String? = nil, icon: UIImage? = nil) {
        self.theme = theme
        super.init(frame: .zero)
        self.isSelected = isSelected

        if let title = title {
            setTitle(title, for: .normal)
            setTitleColor(Colors.Text.primary.color, for: .normal)
            titleLabel?.font = Fonts.Styles.body
        }

        if let icon = icon {
            setImage(icon, for: .normal)
            tintColor = Colors.Text.primary.color
        }

        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAppearance() {
        backgroundColor = isSelected ? Colors.Constants.white.color : .clear
        layer.cornerRadius = ThemeSelectorViewConstants.buttonCornerRadius
    }
}

// MARK: - ThemeOptionButton Constants

private enum ThemeSelectorViewConstants {
    static let padding: CGFloat = 16.0
    static let spacing: CGFloat = 12.0
    static let cornerRadius: CGFloat = 18.0
    static let containerHeight: CGFloat = 40.0
    static let containerCornerRadius: CGFloat = 20.0
    static let buttonInset: CGFloat = 2.0
    static let buttonSpacing: CGFloat = 2.0
    static let buttonCornerRadius: CGFloat = 18.0
}
